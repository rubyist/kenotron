class KenKenDesignerController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    
    @grid_view = KenKenGridView.alloc.initWithGridSize(4)

    # No idea how to make this work right. I want it centered horizontally
    Motion::Layout.new do |layout|
      layout.view view
      layout.subviews "grid" => @grid_view
      layout.metrics "top" => 90, "margin" => 90, "height" => @grid_view.frame.height, "width" => @grid_view.frame.width
      layout.vertical "|-(top)-[grid(==height)]"
      layout.horizontal "|-(margin)-[grid(==width)]"
    end
  end
end
