class KenKenDesignerController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    
    @grid_view = KenKenGridView.alloc.initWithGridSize(4)

    @solve_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @solve_button.setTitle("Solve", forState:UIControlStateNormal)
    @solve_button.addTarget(self, action:"solve_puzzle", forControlEvents:UIControlEventTouchUpInside)

    # No idea how to make this work right. I want it centered horizontally
    Motion::Layout.new do |layout|
      layout.view view
      layout.subviews "grid" => @grid_view, "solve" => @solve_button
      layout.metrics "top" => 90, "margin" => 90, "height" => @grid_view.frame.height, "width" => @grid_view.frame.width
      layout.vertical "|-(top)-[grid(==height)]-[solve]"
      layout.horizontal "|-(margin)-[grid(==width)]"
      layout.horizontal "|-(margin)-[solve(==grid)]"
    end
  end
  
  def solve_puzzle
    puts "Let's solve it!"
  end
end
