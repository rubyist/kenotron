class KenKenCellView < UIView
  attr_accessor :grid
  attr_accessor :cellIndex

  BorderSize      = 4.0

  def initWithFrame(frame)
    super
    
    @selected = false
    
    self.backgroundColor = UIColor.clearColor
    self.userInteractionEnabled = false

    lato18 = UIFont.fontWithName("Lato", size: 18)

    @numOpLabel = UILabel.alloc.initWithFrame(CGRect.make(x: 7, y: 8, width: 60, height: 14))
    @numOpLabel.font = lato18
    @numOpLabel.text = ""
    @numOpLabel.textColor = KenotronConstants::LightTextColor
    @numOpLabel.backgroundColor = UIColor.clearColor
    self.addSubview(@numOpLabel)

    lato36 = UIFont.fontWithName("Lato", size: 36)

    @numberLabel = UILabel.alloc.initWithFrame(CGRect.make(x:36, y:30, width: 40, height: 50))
    @numberLabel.font = lato36
    @numberLabel.text = ""
    @numberLabel.textColor = KenotronConstants::TextColor
    @numberLabel.backgroundColor = UIColor.clearColor
    self.addSubview(@numberLabel)


    self
  end
  
  def drawRect(rect)
    cellWidth = self.frame.width - (BorderSize * 2)
    cellheight = cellWidth

    context = UIGraphicsGetCurrentContext()
    CGContextSaveGState(context)

    if @selected
      CGContextSetFillColorWithColor(context, KenotronConstants::CellSelectedColor.CGColor)
    else
      CGContextSetFillColorWithColor(context, KenotronConstants::CellDeselectedColor.CGColor)
    end

    CGContextFillRect(context, CGRect.make(x:BorderSize, y:BorderSize, width:cellWidth, height:cellheight))

    CGContextRestoreGState(context)
  end
  
  def set_num_op(num_op)
    @numOpLabel.text = num_op
  end

  def setNumber(number)
    @numberLabel.text = number.to_s
  end

  def select
    @selected = true
    setNeedsDisplay
  end
  
  def deselect
    @selected = false
    setNeedsDisplay
  end

  def reset
    @numOpLabel.text = ""
    @numberLabel.text = ""
  end
end
