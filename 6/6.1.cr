timers = File.read("#{__DIR__}/input.txt").split(',').map(&.to_i)

80.times do |i|
  newborns_count = timers.count { |timer| timer == 0 }

  timers.map! do |timer|
    timer == 0 ? 6 : (timer - 1)
  end

  newborns_count.times do
    timers << 8
  end
end

puts timers.size
