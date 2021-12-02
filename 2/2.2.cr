x = 0
depth = 0
aim = 0

instructions = File.read_lines("#{__DIR__}/input.txt")
instructions.each do |instruction|
  case instruction
  when /forward (\d+)/
    units = $1.to_i
    x += units
    depth += aim * units
  when /down (\d+)/
    aim += $1.to_i
  when /up (\d+)/
    aim -= $1.to_i
  end
end

puts x * depth
