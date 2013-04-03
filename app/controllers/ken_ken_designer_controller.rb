class KenKenDesignerController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    
    grid_view = KenKenGridView.alloc.initWithGridSize(6)
    self.view.addSubview(grid_view)
  end
end
