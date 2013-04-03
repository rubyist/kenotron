class KenKenCellView < UIView
  attr_accessor :grid
  
  DeselectedColor = '#e0dfd1'.to_color
  SelectedColor   = '#d1c662'.to_color
  
  def initWithFrame(frame)
    super
    
    self.backgroundColor = DeselectedColor
    self.userInteractionEnabled = false
    
    self
  end
  
  def select
    self.backgroundColor = SelectedColor
  end
  
  def deselect
    self.backgroundColor = DeselectedColor
  end
end
