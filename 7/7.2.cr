positions = File.read("#{__DIR__}/input.txt").split(',').map(&.to_i)

min_position, max_position = positions.minmax
min_fuel = (min_position..max_position).min_of do |candidate_position|
  positions.sum do |position|
    distance = (candidate_position - position).abs
    distance * (distance + 1) / 2
  end
end
puts min_fuel
