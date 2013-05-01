class KenKenDesignerController < UIViewController
  def initWithGridSize(size)
    @size = size.to_i
    self.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super
    self.view.backgroundColor = KenotronConstants::BackgroundColor

    lato36 = UIFont.fontWithName("Lato", size: 36)

    @gridView = KenKenGridView.alloc.initWithGridSize(@size)

    @solveButton = UIButton.buttonWithType(UIButtonTypeCustom)
    @solveButton.backgroundColor = KenotronConstants::ButtonColor
    @solveButton.setTitleColor(KenotronConstants::TextColor, forState:UIControlStateNormal)
    @solveButton.setTitle("Solve", forState:UIControlStateNormal)
    @solveButton.addTarget(self, action: "solvePuzzle", forControlEvents:UIControlEventTouchUpInside)
    @solveButton.titleLabel.font = lato36

    @resetButton = UIButton.buttonWithType(UIButtonTypeCustom)
    @resetButton.backgroundColor = KenotronConstants::ResetButtonColor
    @resetButton.setTitleColor(KenotronConstants::TextColor, forState:UIControlStateNormal)
    @resetButton.setTitle("Reset", forState:UIControlStateNormal)
    @resetButton.addTarget(self, action:"resetPuzzle", forControlEvents:UIControlEventTouchUpInside)
    @resetButton.titleLabel.font = lato36

    @homeButton = UIButton.buttonWithType(UIButtonTypeCustom)
    @homeButton.backgroundColor = KenotronConstants::HomeButtonColor
    @homeButton.setTitleColor(KenotronConstants::TextColor, forState:UIControlStateNormal)
    @homeButton.setTitle("New Puzzle", forState:UIControlStateNormal)
    @homeButton.addTarget(self, action:"home", forControlEvents:UIControlEventTouchUpInside)
    @homeButton.titleLabel.font = lato36

    # No idea how to make this work right. I want it centered horizontally

    Motion::Layout.new do |layout|
      layout.view view
      layout.subviews "grid" => @gridView, "solve" => @solveButton, "reset" => @resetButton, "home" => @homeButton
      layout.metrics "top" => 45, "margin" => (view.frame.width - @gridView.frame.width)/2, "height" => @gridView.frame.height, "width" => @gridView.frame.width
      layout.vertical "|-(top)-[grid(==height)]-[solve(==60)]-[reset(==60)]-[home(==60)]"
      layout.horizontal "|-(margin)-[grid(==width)]"
      layout.horizontal "|-(margin)-[solve(==grid)]"
      layout.horizontal "|-(margin)-[reset(==grid)]"
      layout.horizontal "|-(margin)-[home(==grid)]"
    end
  end
  
  def solvePuzzle
    puts "Sovling puzzle"

    start = Time.now
    solution = NekNek.solve(NekNek::Puzzle.new(@gridView.stringForSolver))
    stop = Time.now

    if solution
      puts "Solved in #{stop - start} seconds"
      solution.each do |cell, answer|
        @gridView.cells[cell].setNumber(answer)
      end
    else
      puts "Could not solve :("
    end
  end

  def resetPuzzle
    @gridView.reset
  end

  def home
    self.dismissViewControllerAnimated(true, completion:nil)
  end
end
