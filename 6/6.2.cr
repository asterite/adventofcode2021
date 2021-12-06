timers = File.read("#{__DIR__}/input.txt").split(',').map(&.to_i)

instances = 0.to(8).to_h { |number| {number, 0_i64} }

timers.each do |timer|
  instances[timer] += 1
end

256.times do |day|
  instances = 0.to(8).to_h do |state|
    case state
    when 6
      {6, instances[0] + instances[7]}
    when 8
      {8, instances[0]}
    else
      {state, instances[state + 1]}
    end
  end
end

puts instances.values.sum
