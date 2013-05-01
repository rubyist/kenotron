class SelectPuzzleController < UIViewController
  def viewDidLoad
    super

    self.view.backgroundColor = KenotronConstants::BackgroundColor

    lato72 = UIFont.fontWithName("Lato", size: 72)

    @selectLabel = UILabel.alloc.initWithFrame(CGRect.make(x: 160, y: 94, width: 768, height: 79))
    @selectLabel.font = lato72
    @selectLabel.text = "Select A Puzzle"
    @selectLabel.textColor = KenotronConstants::LabelTextColor
    @selectLabel.backgroundColor = UIColor.clearColor
    self.view.addSubview(@selectLabel)

    puzzles = [
        {x:  94, y: 208, title: '3x3', cells: 3},
        {x: 294, y: 208, title: '4x4', cells: 4},
        {x: 494, y: 208, title: '5x5', cells: 5},
        {x:  94, y: 408, title: '6x6', cells: 6},
        {x: 294, y: 408, title: '7x7', cells: 7},
        {x: 494, y: 408, title: '8x8', cells: 8},
        {x: 294, y: 608, title: '9x9', cells: 9}
    ]

    puzzles.each do |puzzle|
      button = UIButton.buttonWithType(UIButtonTypeCustom)
      button.setFrame(CGRect.make(x: puzzle[:x], y: puzzle[:y], width: 180, height: 180))
      button.backgroundColor = KenotronConstants::CellDeselectedColor
      button.setTitle(puzzle[:title], forState:UIControlStateNormal)
      button.setTitleColor(KenotronConstants::SelectTextColor, forState:UIControlStateNormal)
      button.titleLabel.font = lato72
      button.when(UIControlEventTouchUpInside) do
        @designerController = KenKenDesignerController.alloc.initWithGridSize(puzzle[:cells])
        self.presentViewController(@designerController, animated:true, completion:nil)
      end
      self.view.addSubview(button)
    end

  end
end
