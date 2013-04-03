class NumOpController < UIViewController
  attr_accessor :parent
  
  def initWithCageCount(cage_count)
    self.initWithNibName(nil, bundle:nil)
    @cage_count = cage_count
    
    self
  end
  
  def viewDidLoad
    super
    
    view.frame = CGRect.make(x: 0, y: 0, width: 320, height: 140)
    view.backgroundColor = UIColor.whiteColor
    
    @number = UITextField.alloc.initWithFrame(CGRectZero)
    @number.borderStyle = UITextBorderStyleRoundedRect
    @number.enablesReturnKeyAutomatically = true
    @number.returnKeyType = UIReturnKeyDone
    @number.autocapitalizationType = UITextAutocapitalizationTypeNone
    @number.becomeFirstResponder
    
    @operation = UISegmentedControl.alloc.initWithItems(operation_segments)
    @operation.addTarget(self, action:"set_operation", forControlEvents:UIControlEventValueChanged)
    
    Motion::Layout.new do |layout|
      layout.view view
      layout.subviews "number" => @number, "operation" => @operation
      layout.metrics "top" => 20, "margin" => 20, "height" => 40
      layout.vertical "|-top-[number(==height)]-margin-[operation]"
      layout.horizontal "|-margin-[number]-margin-|"
      layout.horizontal "|-margin-[operation]-margin-|"
    end
  end
  
  def set_operation
    if @number.text.to_i > 0 # TODO Better verification?
      parent.set_number_operation(@number.text.to_i, operation_segments[@operation.selectedSegmentIndex])
    else
      @operation.selectedSegmentIndex = UISegmentedControlNoSegment
    end
  end
  
  def operation_segments
    case @cage_count
    when 1
      ['=']
    when 2
      ['+', '-', '×', '÷']
    else
      ['+', '-', '×']
    end
  end
end
