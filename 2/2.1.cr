x = 0
depth = 0

instructions = File.read_lines("#{__DIR__}/input.txt")
instructions.each do |instruction|
  case instruction
  when /forward (\d+)/
    x += $1.to_i
  when /down (\d+)/
    depth += $1.to_i
  when /up (\d+)/
    depth -= $1.to_i
  end
end

puts x * depth
