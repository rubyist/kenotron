class KenKenCage
  attr_reader :target
  attr_reader :operation
  attr_reader :cells

  def initialize(target, operation, cells)
    @target = target
    @operation = operation
    @cells = cells
  end

  def borderPoints
    points[:border_points]
  end

  def points
    cagePoints = []
    cells.map(&:frame).each do |rect|

      # Top
      cagePoints << [CGPoint.make(x: rect.x, y: rect.y), CGPoint.make(x: rect.x + rect.width, y: rect.y)]

      # Right
      cagePoints << [CGPoint.make(x: rect.x + rect.width, y: rect.y), CGPoint.make(x: rect.x + rect.width, y: rect.y + rect.height)]

      # Bottom
      cagePoints << [CGPoint.make(x: rect.x, y: rect.y + rect.height), CGPoint.make(x: rect.x + rect.width, y: rect.y + rect.height)]

      # Left
      cagePoints << [CGPoint.make(x: rect.x, y: rect.y), CGPoint.make(x: rect.x, y: rect.y + rect.height)]

    end

    cage_inner_points = cagePoints.select { |p| cagePoints.count(p) >= 2 }.uniq
    cage_border_points = (cagePoints - cage_inner_points).uniq

    {
        inner_points: cage_inner_points,
        border_points: cage_border_points
    }
  end

  def solverString
    "#{solverOperation} #{target} #{cells.map(&:cellIndex).join(' ')}"
  end

  private
  def solverOperation
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