input = File.read("#{__DIR__}/input.txt").chomp
case input
when /target area: x=(\-?\d+)..(\-?\d+), y=(\-?\d+)..(\-?\d+)/
  target_x = $1.to_i..$2.to_i
  target_y = $3.to_i..$4.to_i
else
  raise "can't parse input"
end

vx_options = (1..target_x.end).to_a
vy_options = (target_y.begin..-target_y.begin).to_a

possible_velocities = vx_options
  .cartesian_product(vy_options)
  .select { |(vx, vy)| reaches_target?(vx, vy, target_x, target_y) }

max_vy = possible_velocities.max_of(&.[1])
part1 = (max_vy + 1) * max_vy // 2

puts "Part 1: #{part1}"
puts "Part 2: #{possible_velocities.size}"

def reaches_target?(vx, vy, target_x, target_y)
  x = 0
  y = 0

  while x <= target_x.end && y >= target_y.begin
    x += vx
    y += vy

    return true if target_x.includes?(x) && target_y.includes?(y)

    vx -= 1 if vx > 0
    vx += 1 if vx < 0
    vy -= 1
  end

  false
end
