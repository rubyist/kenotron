class KenKenGridView < UIView
  attr_accessor :size
  attr_accessor :cells
  attr_accessor :cages
  
  def initWithGridSize(size)
    cell_width = 648.0 / size # 648 = max usable space in portrait with 40 margins
    cell_width = [cell_width, 72.0, 98.0].sort[1] # Clamp cell width between 72 and 80

    grid_width = (cell_width * size) + 8  # Cells plus borders
    grid_height = grid_width

    self.initWithFrame(CGRect.make(x:0, y:0, width:grid_width, height:grid_height))
    self.backgroundColor = '#dddbba'.to_color

    @size = size
    @cells = []
    @cages = []
    
    cell_height = cell_width
    
    main_rect = CGRect.make(x:4.0, y:4.0, width:cell_width, height:cell_height)

    cell_index = 0
    size.times do |n|
      size.times do |m|
        cell = KenKenCellView.alloc.initWithFrame(main_rect)
        cell.grid = self
        cell.cell_index = cell_index
        cell_index += 1
        self.addSubview(cell)
        
        cells << cell
        main_rect = main_rect.beside
      end
      main_rect = main_rect.below
      main_rect.x = 4.0
    end
    
    self
  end
  
  def drawRect(rect)
    return if @cages.empty?

    context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context)

    CGContextSetStrokeColorWithColor(context, '#eaafa3'.to_color.CGColor)
    CGContextSetLineWidth(context, 8.0)


    @cages.each do |cage|
      cage.border_points.each do |points|
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
    @cells.each do |cell|
      cell.deselect
    end
    
    touchPoint = touches.anyObject.locationInView(self)
    @cells.each do |cell|
      if cell.pointInside(convertPoint(touchPoint, toView:cell), withEvent:event)
        @touchedCells << cell unless @touchedCells.include?(cell)
        cell.select
      end
    end
  end
  
  def touchesMoved(touches, withEvent:event)
    touchPoint = touches.anyObject.locationInView(self)
    
    @cells.each do |cell|
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
    

    # TODO: Invalidate any cages we're draing over with this cage
  end
  
  def set_number_operation(number, operation)
    @popover.dismissPopoverAnimated(true)
    
    northwest_cell = northwest_cell_of_cage(@touchedCells)
    if operation == "="
      northwest_cell.set_num_op("#{number}")
    else
      northwest_cell.set_num_op("#{number} #{operation}")
    end

    @cages << KenKenCage.new(number, operation, @touchedCells)

    # Ensure cages are drawn
    @touchedCells.each(&:deselect)
    setNeedsDisplay

    @touchedCells = []
  end
  
  def northwest_cell_of_cage(cage)
    cage_points = cage.map(&:frame)
    min_y_value = cage_points.min_by(&:y).y
    min_y_points = cage_points.select {|p| p.y == min_y_value}
    northwest_point = min_y_points.min_by(&:x)
    cage[cage_points.index(northwest_point)]    
  end

  def string_for_solver
    "#{@size} #{@cages.map(&:solver_string).join(' ')}"
  end
end
