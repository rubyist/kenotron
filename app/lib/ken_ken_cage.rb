class KenKenCage
  attr_reader :target
  attr_reader :operation
  attr_reader :cells

  def initialize(target, operation, cells)
    @target = target
    @operation = operation
    @cells = cells
  end

  def border_points
    points[:border_points]
  end

  def points
    cage_points = []
    cells.map(&:frame).each do |rect|

      # Top
      cage_points << [CGPoint.make(x: rect.x, y: rect.y), CGPoint.make(x: rect.x + rect.width, y: rect.y)]

      # Right
      cage_points << [CGPoint.make(x: rect.x + rect.width, y: rect.y), CGPoint.make(x: rect.x + rect.width, y: rect.y + rect.height)]

      # Bottom
      cage_points << [CGPoint.make(x: rect.x, y: rect.y + rect.height), CGPoint.make(x: rect.x + rect.width, y: rect.y + rect.height)]

      # Left
      cage_points << [CGPoint.make(x: rect.x, y: rect.y), CGPoint.make(x: rect.x, y: rect.y + rect.height)]

    end

    cage_inner_points = cage_points.select { |p| cage_points.count(p) >= 2 }.uniq
    cage_border_points = (cage_points - cage_inner_points).uniq

    {
        inner_points: cage_inner_points,
        border_points: cage_border_points
    }
  end

  def solver_string
    "#{solver_operation} #{target} #{cells.map(&:cell_index).join(' ')}"
  end

  private
  def solver_operation
    case operation
    when '+'
      '+'
    when '-'
      '-'
    when '×'
      '*'
    when '÷'
      '/'
    when '='
      '!'
    end
  end
end