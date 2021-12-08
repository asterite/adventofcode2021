lines = File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.split(" | ").map(&.split))

solution = lines.sum do |(inputs, outputs)|
  outputs.count(&.size.in?(2, 4, 3, 7))
end

puts solution
