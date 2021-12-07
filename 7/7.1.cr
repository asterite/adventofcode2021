positions = File.read("#{__DIR__}/input.txt").split(',').map(&.to_i)

min_position, max_position = positions.minmax
min_fuel = (min_position..max_position).min_of do |candidate_position|
  positions.sum do |position|
    (candidate_position - position).abs
  end
end
puts min_fuel
