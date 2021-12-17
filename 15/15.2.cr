class RiskComputer
  getter map : Array(Array(Int32))
  getter risk_map : Array(Array(Int32?))
  getter width : Int32
  getter height : Int32

  def initialize(@map : Array(Array(Int32)))
    @width = @map.first.size
    @height = @map.size
    @risk_map = Array.new(@height) { Array(Int32?).new(@width, nil) }
    @risk_map[@height - 1][@width - 1] = @map[@height - 1][@width - 1]
  end

  def compute
    points_to_compute = Deque{ {width - 2, height - 1} }

    while point = points_to_compute.shift?
      x, y = point
      compute_risk(x, y, points_to_compute)
    end

    risk_map[0][0].not_nil! - map[0][0]
  end

  def compute_risk(x, y, points_to_compute)
    neighbors = { {x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1} }

    neighbors_min_risk = nil
    neighbors.each do |nx, ny|
      next unless in_bounds?(nx, ny)

      nrisk = risk_map[ny][nx]
      next unless nrisk

      if !neighbors_min_risk || nrisk < neighbors_min_risk
        neighbors_min_risk = nrisk
      end
    end

    new_risk = @map[y][x] + neighbors_min_risk.not_nil!
    current_risk = @risk_map[y][x]
    if !current_risk || new_risk < current_risk
      @risk_map[y][x] = new_risk

      neighbors.each do |point|
        points_to_compute << point if in_bounds?(*point) && !points_to_compute.includes?(point)
      end
    end
  end

  def in_bounds?(x, y)
    0 <= x < width && 0 <= y < height
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
