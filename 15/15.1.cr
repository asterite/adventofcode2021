class RiskComputer
  getter map : Array(Array(Int32))
  getter risk_map : Array(Array(Int32))
  getter width : Int32
  getter height : Int32

  def initialize(@map : Array(Array(Int32)))
    @width = @map.first.size
    @height = @map.size
    @risk_map = Array.new(@height) { Array.new(@width, 0) }
  end

  def compute
    points_to_compute = [{width - 1, height - 1}]

    while point = points_to_compute.shift?
      x, y = point
      compute_risk(x, y) if risk_map[y][x] == 0

      points_to_compute << {x - 1, y} if x > 0 && !points_to_compute.includes?({x - 1, y})
      points_to_compute << {x, y - 1} if y > 0 && !points_to_compute.includes?({x, y - 1})
    end

    risk_map[0][0] - map[0][0]
  end

  def compute_risk(x = width - 1, y = height - 1)
    right_risk =
      if x == width - 1
        nil
      else
        risk_map[y][x + 1]
      end

    bottom_risk =
      if y == height - 1
        nil
      else
        risk_map[y + 1][x]
      end

    neighbors_risk =
      if right_risk && bottom_risk
        {right_risk, bottom_risk}.min
      else
        right_risk || bottom_risk || 0
      end

    risk_map[y][x] =
      if x == 0 && y == 0
        neighbors_risk
      else
        map[y][x] + neighbors_risk
      end
  end
end

map = File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.chars.map(&.to_i))

computer = RiskComputer.new(map)
risk = computer.compute
puts "Part 1: #{risk}"

width = map.first.size
height = map.size

large_map = Array.new(height * 5) do |y|
  Array.new(width * 5) do |x|
    outer_x, inner_x = x.divmod(width)
    outer_y, inner_y = y.divmod(width)
    increment = outer_x + outer_y
    new_value = map[inner_y][inner_x] + increment
    new_value = new_value - 9 if new_value > 9
    new_value
  end
end

computer = RiskComputer.new(large_map)
risk = computer.compute
puts "Part 2: #{risk}"
