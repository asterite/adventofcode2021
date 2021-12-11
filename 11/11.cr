grid = File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.chars.map(&.to_i))

total_flashes = part1(grid.clone)
puts "Part 1: #{total_flashes}"

flashy_step = part2(grid.clone)
puts "Part 2: #{flashy_step}"

def part1(grid)
  100.times.sum do
    grid, flashes = step(grid)
    flashes
  end
end

def part2(grid)
  number_of_octopuses = grid.size * grid.first.size

  (1..).find do |i|
    grid, flashes = step(grid)
    flashes == number_of_octopuses
  end
end

def step(grid)
  # Increase every energy level by 1
  # Each cell value will be the energy level,
  # or nil if a cell flashed
  new_grid = grid.map(&.map(&.+(1).as(Int32?)))

  # Check flash and propagate
  new_grid.size.times do |y|
    new_grid.first.size.times do |x|
      check_flash(new_grid, x, y)
    end
  end

  flashes = new_grid.sum(&.count(&.nil?))

  # Turn cell that flashed (nil values) into zeros
  new_grid = new_grid.map do |row|
    row.map do |value|
      value || 0
    end
  end

  {new_grid, flashes}
end

def check_flash(grid, x, y)
  value = grid[y][x]
  return unless value
  return unless value > 9

  grid[y][x] = nil

  [
    {x - 1, y - 1},
    {x, y - 1},
    {x + 1, y - 1},
    {x - 1, y},
    {x + 1, y},
    {x - 1, y + 1},
    {x, y + 1},
    {x + 1, y + 1},
  ].each do |nx, ny|
    next unless 0 <= ny < grid.size
    next unless 0 <= nx < grid.first.size

    nvalue = grid[ny][nx]
    next unless nvalue

    grid[ny][nx] = nvalue + 1
    check_flash(grid, nx, ny)
  end
end
