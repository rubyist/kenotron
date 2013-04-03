class CageManager
  def self.cageToPoints(cage)    
    points = []
    cage.map(&:frame).each do |rect|

      # Top
      points << [CGPoint.make(x: rect.x, y: rect.y), CGPoint.make(x: rect.x + rect.width, y: rect.y)]
    
      # Right
      points << [CGPoint.make(x: rect.x + rect.width, y: rect.y), CGPoint.make(x: rect.x + rect.width, y: rect.y + rect.height)]
    
      # Bottom
      points << [CGPoint.make(x: rect.x, y: rect.y + rect.height), CGPoint.make(x: rect.x + rect.width, y: rect.y + rect.height)]
    
      # Left
      points << [CGPoint.make(x: rect.x, y: rect.y), CGPoint.make(x: rect.x, y: rect.y + rect.height)]
      
    end
    
    inner_points = points.select { |p| points.count(p) >= 2 }.uniq
    border_points = (points - inner_points).uniq
    
    {
      inner_points: inner_points,
      border_points: border_points
    }
  end
end
