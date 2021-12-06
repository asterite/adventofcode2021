timers = File.read("#{__DIR__}/input.txt").split(',').map(&.to_i)

instances = 0.to(8).to_h { |number| {number, 0_i64} }

timers.each do |timer|
  instances[timer] += 1
end

256.times do |day|
  next_instances = 0.to(8).to_h { |number| {number, 0_i64} }

  0.to(8) do |state|
    case state
    when 6
      next_instances[6] = instances[0] + # reset lanternfish
                          instances[7]   # usual lanternfish
    when 8
      next_instances[8] = instances[0]
    else
      next_instances[state] = instances[state + 1]
    end
  end

  instances = next_instances
end

puts instances.values.sum
