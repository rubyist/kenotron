class KenKenCellView < UIView
  attr_accessor :grid
  
  BorderSize      = 4.0
  DeselectedColor = '#e0dfd1'.to_color
  SelectedColor   = '#d1c662'.to_color
  
  def initWithFrame(frame)
    super
    
    @selected = false
    
    self.backgroundColor = UIColor.clearColor #DeselectedColor
    self.userInteractionEnabled = false

    self
  end
  
  def drawRect(rect)
    cell_width = self.frame.width - (BorderSize * 2)
    cell_height = cell_width

    context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context)

    if @selected
      CGContextSetFillColorWithColor(context, SelectedColor.CGColor)
    else
      CGContextSetFillColorWithColor(context, DeselectedColor.CGColor)
    end

    CGContextFillRect(context, CGRect.make(x:BorderSize, y:BorderSize, width:cell_width, height:cell_height))

    CGContextRestoreGState(context)
  end

  def select
    @selected = true
    setNeedsDisplay
  end
  
  def deselect
    @selected = false
    setNeedsDisplay
  end
end
