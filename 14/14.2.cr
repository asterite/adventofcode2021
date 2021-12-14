lines = File.read_lines("#{__DIR__}/input.txt")
template = lines.shift.chars

# Ignore blank line
lines.shift

rules = lines.to_h do |line|
  from, to = line.split(" -> ")
  { {from[0], from[1]}, to[0] }
end

pair_counts = Hash({Char, Char}, Int64).new(0)
template.each_cons_pair do |char1, char2|
  pair_counts[{char1, char2}] += 1
end

char_counts = Hash(Char, Int64).new(0)
template.each do |char|
  char_counts[char] += 1
end

40.times do
  pair_counts = step(pair_counts, rules, char_counts)
end

counts = char_counts.values.sort
puts counts.last - counts.first

def step(pair_counts, rules, char_counts)
  next_pair_counts = Hash({Char, Char}, Int64).new(0)

  pair_counts.each do |(char1, char2), count|
    insertion_char = rules[{char1, char2}]
    char_counts[insertion_char] += count

    next_pair_counts[{char1, insertion_char}] += count
    next_pair_counts[{insertion_char, char2}] += count
  end

  next_pair_counts
end
