class KenKenGridView < UIView
  attr_accessor :size
  attr_accessor :cells
  attr_accessor :cages
  
  def initWithGridSize(size)
    cellWidth = 648.0 / size # 648 = max usable space in portrait with 40 margins
    cellWidth = [cellWidth, 72.0, 98.0].sort[1] # Clamp cell width between 72 and 80

    gridWidth = (cellWidth * size) + 8  # Cells plus borders
    gridHeight = gridWidth

    self.initWithFrame(CGRect.make(x:0, y:0, width:gridWidth, height:gridHeight))
    self.backgroundColor = KenotronConstants::GridOutlineColor

    @size = size
    @cells = {}
    @cages = []
    
    cellHeight = cellWidth
    
    mainRect = CGRect.make(x:4.0, y:4.0, width:cellWidth, height:cellHeight)

    alphabet = ('A'..'Z').to_a
    numbers = (1..9).to_a

    cell_index = 0
    size.times do |n|
      size.times do |m|
        cell = KenKenCellView.alloc.initWithFrame(mainRect)
        cell.grid = self
        cell.cellIndex = "#{alphabet[n]}#{numbers[m]}"
        self.addSubview(cell)
        
        cells[cell.cellIndex] = cell
        mainRect = mainRect.beside
      end
      mainRect = mainRect.below
      mainRect.x = 4.0
    end
    
    self
  end
  
  def drawRect(rect)
    return if @cages.empty?

    context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context)

    CGContextSetStrokeColorWithColor(context, KenotronConstants::GridHighlightColor.CGColor)
    CGContextSetLineWidth(context, 8.0)


    @cages.each do |cage|
      cage.borderPoints.each do |points|
        if points[0].y == points[1].y # Horizontal line
          CGContextMoveToPoint(context, points[0].x - 4, points[0].y)
          CGContextAddLineToPoint(context, points[1].x + 4, points[1].y)
        else # Vertical line
          CGContextMoveToPoint(context, points[0].x, points[0].y)
          CGContextAddLineToPoint(context, points[1].x, points[1].y)
        end
        CGContextStrokePath(context)
      end
    end

    CGContextRestoreGState(context)
  end

  def touchesBegan(touches, withEvent:event)
    @touchedCells = []
    @cells.values.each(&:deselect)

    touchPoint = touches.anyObject.locationInView(self)
    @cells.values.each do |cell|
      if cell.pointInside(convertPoint(touchPoint, toView:cell), withEvent:event)
        @touchedCells << cell unless @touchedCells.include?(cell)
        cell.select
      end
    end
  end
  
  def touchesMoved(touches, withEvent:event)
    touchPoint = touches.anyObject.locationInView(self)
    
    @cells.values.each do |cell|
      if cell.pointInside(convertPoint(touchPoint, toView:cell), withEvent:event)
        @touchedCells << cell unless @touchedCells.include?(cell)
        cell.select
      end
    end
  end
  
  def touchesEnded(touches, withEvent:event)
    return if @touchedCells.count == 0

    # Pop up the big question
    snvc = NumOpController.alloc.initWithCageCount(@touchedCells.count)
    if UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad
      @popover = UIPopoverController.alloc.initWithContentViewController(snvc)
      snvc.parent = self
      @popover.setPopoverContentSize(snvc.view.frame.size)
      @popover.delegate = self
      @popover.presentPopoverFromRect(@touchedCells.last.frame, inView:self, permittedArrowDirections:UIPopoverArrowDirectionAny, animated:true)
    end
  end
  
  def setNumberOperation(number, operation)
    @popover.dismissPopoverAnimated(true)

    # Bust any cages we drew over
    touchedCellIndices = @touchedCells.map(&:cellIndex)
    bustedCages = @cages.select {|cage| cage.cells.any? {|cell| touchedCellIndices.include?(cell.cellIndex) } }
    bustedCages.each do |cage|
      cage.cells.each(&:reset)
      @cages.delete(cage)
    end

    # Draw target/op in northwest cell
    northwestCell = northwestCellOfCage(@touchedCells)
    if operation == "="
      northwestCell.set_num_op("#{number}")
    else
      northwestCell.set_num_op("#{number} #{operation}")
    end

    @cages << KenKenCage.new(number, operation, @touchedCells)

    # Ensure cages are drawn
    @touchedCells.each(&:deselect)
    setNeedsDisplay

    @touchedCells = []
  end
  
  def northwestCellOfCage(cage)
    cage_points = cage.map(&:frame)
    min_y_value = cage_points.min_by(&:y).y
    min_y_points = cage_points.select {|p| p.y == min_y_value}
    northwest_point = min_y_points.min_by(&:x)
    cage[cage_points.index(northwest_point)]    
  end

  def stringForSolver
    "# #{@size}\n#{@cages.map(&:solverString).join("\n")}"
  end

  def reset
    @cells.values.each(&:reset)
    @cages = []
    setNeedsDisplay
  end
end
