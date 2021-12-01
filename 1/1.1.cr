increases = 0

File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.to_i)
  .each_cons_pair do |m1, m2|
    increases += 1 if m2 > m1
  end

puts increases
