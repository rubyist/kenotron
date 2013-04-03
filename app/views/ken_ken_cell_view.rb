class KenKenCellView < UIView
  attr_accessor :grid
  
  BorderSize      = 4.0
  DeselectedColor = '#e0dfd1'.to_color
  SelectedColor   = '#d1c662'.to_color
  
  def initWithFrame(frame)
    super
    
    @selected = false
    
    self.backgroundColor = UIColor.clearColor
    self.userInteractionEnabled = false
    
    @num_op_label = UILabel.alloc.initWithFrame(CGRect.make(x: 7, y: 5, width: 60, height: 14))
    @num_op_label.text = ""
    @num_op_label.backgroundColor = UIColor.clearColor
    self.addSubview(@num_op_label)

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
  
  def set_num_op(num_op)
    @num_op_label.text = num_op
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
