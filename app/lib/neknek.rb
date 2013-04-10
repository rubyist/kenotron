# This code is a quick conversion to ruby of a kenken solver written in Python by Michael Heyeck.
# You can read his great articles about it here: http://www.mlsite.net/neknek/
# The code specifically modeled in this file is here: http://www.mlsite.net/blog/wp-content/uploads/2009/03/neknek_0.py

module NekNek
  def self.first_true(iterable)
    iterable.find {|x| x}
  end

  def self.can_make_sum_p(t, sets)
    if sets.empty?
      t == 0
    else
      head = sets[0]
      tail = sets[1..-1]
      head.select {|e| e <= t}.any? {|e| can_make_sum_p(t-e, tail)}
    end
  end

  def self.can_make_product_p(t, sets)
    if sets.empty?
      t == 1
    else
      head = sets[0]
      tail = sets[1..-1]
      head.select {|e| t % e == 0}.any? {|e| can_make_product_p(t/e, tail)}
    end
  end

  class Constraint
    attr_reader :value, :cells
    # value: integer
    # cells: set of IDs (strings) of the cells to which the constraint will be applied
    def initialize(value, *cells)
      @cells = cells # Need a set
      @value = value.to_i
    end

    # overridden by subclasses, tests whether or not a given integer may be used to satisfy
    # the constraint, given all possible values of all other cells goverrned by the constraint
    # (context - list of integers)
    def _test_component(component, context)
      true
    end

    # Take a partial solution dictionary, return a "bad" dictionary indicating
    # which possible values should be removed from the partial solution. "Bad"
    # dictionary maps cell IDs to collections of known impossible cell values
    # key: strings representing cell IDs
    # value: strings representing sets of numbers
    def apply(solution)
      d_sets = {}
      cells.each do |c|
        d_sets[c] = solution[c].split('').map(&:to_i)
      end
      d_bad = {}
      d_sets.each do |k, v|
        others = d_sets.reject {|ok,ov| ok == k}.values
        d_bad[k] = v.select {|e| !self._test_component(e, others)}.join('')
      end
      d_bad
    end
  end

  class Assert < Constraint
    def apply(solution)
      d_bad = {}
      cells.each do |c|
        d_bad[c] = solution[c].sub(self.value.to_s, '')
      end
      d_bad
    end
  end

  class Sum < Constraint
    def _test_component(component, context)
      self.value >= component && NekNek.can_make_sum_p(self.value - component, context)
    end
  end


  class Diff < Constraint
    def initialize(value, *cells)
      super
      raise 'Diff constraints must be applied to pairs of cells' if cells.length != 2
    end

    def _test_component(component, context)
      context[0].include?(self.value + component) || context[0].include?(component - self.value)
    end
  end

  class Prod < Constraint
    def _test_component(component, context)
      (self.value % component == 0) && NekNek.can_make_product_p(self.value/component, context)
    end
  end

  class Div < Constraint
    def initialize(value, *cells)
      super
      raise 'Div constraints must be applied to pairs of cells' if cells.length != 2
    end

    def _test_component(component, context)
      context[0].include?(self.value * component) || context[0].include?(component.to_f / self.value)
    end
  end

  class Set < Constraint
    def apply(solution)
      d_bad = {}
      self.cells.each do |c|
        next if solution[c].length != 1

        self.cells.each do |c2|
          if c2 != c
            d_bad[c2] ||= ''
            d_bad[c2] << solution[c]
          end
        end
      end
      d_bad
    end
  end


  class Puzzle
    attr_reader :size, :cages

    Lut = {'!' => NekNek::Assert, '+' => NekNek::Sum, '-' => NekNek::Diff, '*' => NekNek::Prod, '/' => NekNek::Div}
    def initialize(puzzle_string)
      lines = puzzle_string.split("\n").map(&:split)
      if lines[0][0] != '#'
        raise 'Puzzle definitions must begin with a size ("#") line'
      end
      @size = lines[0][1].to_i
      @cages = lines[1..-1].map {|l| Lut[l[0]].new(l[1], *l[2..-1]) }
    end
  end

  def self.constrain(d_constraints, solution, *constraints)
    queue = ::Set.new constraints
    while !queue.empty?
      constraint = queue.first
      queue.delete queue.first

      constraint.apply(solution).each do |cell, bad_choices|
        values = solution[cell]
        bad_choices.split('').each do |choice|
          values = values.gsub(choice, '')
        end
        if values.empty?
          return false
        end

        next if solution[cell] == values

        solution[cell] = values
        d_constraints[cell].each {|c| queue.add(c) }
      end

    end
    return solution
  end

  def self.assign(d_constraints, solution, cell, value)
    solution[cell] = value
    return constrain(d_constraints, solution, *d_constraints[cell])
  end

  def self.search(d_constraints, solution)
    if !solution || solution.values.all? {|v| v.length == 1}
      return solution
    end

    # Find a most-constrained unsolved cell. First cell with minimum length value whose length > 1
    cell = solution.select {|k,v| v.size > 1}.min {|a,b| a[1].length <=> b[1].length}[0]
    return NekNek.first_true(solution[cell].split('').map {|h| search(d_constraints, assign(d_constraints, solution.dup, cell, h)) })
  end

  def self.solve(puzzle)
    rows = ('A'..'Z').to_a[0...puzzle.size].join('')
    cols = ('1'..'9').to_a[0...puzzle.size].join('')

    sets = []
    rows.split('').each do |r|
      sets << Set.new(0, *cols.split('').map { |c| "#{r}#{c}"})
    end

    cols.split('').each do |c|
      sets << Set.new(0, *rows.split('').map {|r| "#{r}#{c}"})
    end

    d_constraints = {}
    rows.split('').each do |r|
      cols.split('').each do |c|
        d_constraints["#{r}#{c}"] = []
      end
    end

    (sets + puzzle.cages).each do |constraint|
      constraint.cells.each do |cell|
        d_constraints[cell] << constraint unless d_constraints[cell].include?(constraint)
      end
    end

    symbols = ('1'..'9').to_a[0...puzzle.size].join('')
    default_table = {}
    d_constraints.each do |k, v|
      default_table[k] = symbols
    end

    search(d_constraints, constrain(d_constraints, default_table, *puzzle.cages))
  end
end
