class KenKenGridView < UIView
  attr_accessor :cells
  
  def initWithGridSize(size)
    grid_width = (size * 90) + ((size + 1) * 8)
    grid_height = grid_width
    
    self.initWithFrame(CGRect.make(x:90, y:90, width:grid_width, height:grid_height))
    self.backgroundColor = '#dddbba'.to_color
    
    @cells = []
    
    cell_width = (frame.width - ((size + 1) * 8)) / size
    cell_height = cell_width
    
    main_rect = CGRect.make(x:8, y:8, width:cell_width, height:cell_height)
    
    size.times do |n|
      size.times do |m|
        cell = KenKenCellView.alloc.initWithFrame(main_rect)
        cell.grid = self
        self.addSubview(cell)
        
        cells << cell
        main_rect = main_rect.beside(8)
      end
      main_rect = main_rect.below(8)
      main_rect.x = 8
    end
    
    self
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
    
    # Draw the cages
  end
end
