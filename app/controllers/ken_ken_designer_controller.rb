class KenKenDesignerController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = KenotronConstants::BackgroundColor
    
    @gridView = KenKenGridView.alloc.initWithGridSize(6)

    @solveButton = UIButton.buttonWithType(UIButtonTypeCustom)
    @solveButton.backgroundColor = KenotronConstants::ButtonColor
    @solveButton.setTitleColor(KenotronConstants::TextColor, forState:UIControlStateNormal)
    @solveButton.setTitle("Solve", forState:UIControlStateNormal)
    @solveButton.addTarget(self, action: "solvePuzzle", forControlEvents:UIControlEventTouchUpInside)

    @resetButton = UIButton.buttonWithType(UIButtonTypeCustom)
    @resetButton.backgroundColor = KenotronConstants::ResetButtonColor
    @resetButton.setTitleColor(KenotronConstants::TextColor, forState:UIControlStateNormal)
    @resetButton.setTitle("Reset", forState:UIControlStateNormal)
    @resetButton.addTarget(self, action:"resetPuzzle", forControlEvents:UIControlEventTouchUpInside)

    # No idea how to make this work right. I want it centered horizontally

    Motion::Layout.new do |layout|
      layout.view view
      layout.subviews "grid" => @gridView, "solve" => @solveButton, "reset" => @resetButton
      layout.metrics "top" => 45, "margin" => (view.frame.width - @gridView.frame.width)/2, "height" => @gridView.frame.height, "width" => @gridView.frame.width
      layout.vertical "|-(top)-[grid(==height)]-[solve(==60)]-[reset(==60)]"
      layout.horizontal "|-(margin)-[grid(==width)]"
      layout.horizontal "|-(margin)-[solve(==grid)]"
      layout.horizontal "|-(margin)-[reset(==grid)]"
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
end
