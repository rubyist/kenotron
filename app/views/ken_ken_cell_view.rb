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

    if self.frame.width > 108 # less than 6x6
      numberFont = UIFont.fontWithName("Lato", size:48)
    else
      numberFont = UIFont.fontWithName("Lato", size:36)
    end

    @numberLabel = UILabel.alloc.initWithFrame(CGRect.make(x:0, y:0, width: self.frame.width, height: self.frame.height))
    @numberLabel.font = numberFont
    @numberLabel.text = ""
    @numberLabel.textColor = KenotronConstants::TextColor
    @numberLabel.backgroundColor = UIColor.clearColor
    @numberLabel.textAlignment = NSTextAlignmentCenter
    @numberLabel.adjustsFontSizeToFitWidth = true
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
