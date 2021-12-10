NEIGHBOUR_DELTAS = { {-1, 0}, {1, 0}, {0, -1}, {0, 1} }

map = File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.chars.map(&.to_i))

map_height = map.size
map_width = map.first.size

lowest_points = [] of {Int32, Int32}

map.each_with_index do |row, y|
  row.each_with_index do |position_height, x|
    lowest = NEIGHBOUR_DELTAS.all? do |dx, dy|
      tx = x + dx
      ty = y + dy
      if 0 <= tx < map_width && 0 <= ty < map_height
        map[ty][tx] > position_height
      else
        true
      end
    end

    lowest_points << {x, y} if lowest
  end
end

basin_sizes = lowest_points.map do |x, y|
  marks_map = Array.new(map_height) { Array.new(map_width, false) }

  flood(map, marks_map, x, y)

  marks_map.sum(&.count(&.itself))
end
basin_sizes.sort!
three_largest_basins = basin_sizes.last(3)
puts three_largest_basins.product

def flood(map, marks_map, x, y)
  return if marks_map[y][x]

  map_height = map.size
  map_width = map.first.size

  marks_map[y][x] = true

  NEIGHBOUR_DELTAS.each do |dx, dy|
    tx = x + dx
    ty = y + dy

    next unless 0 <= tx < map_width
    next unless 0 <= ty < map_height

    target_height = map[ty][tx]
    next if target_height == 9

    position_height = map[y][x]
    next unless position_height < target_height

    flood(map, marks_map, tx, ty)
  end
end
