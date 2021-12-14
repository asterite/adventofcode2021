lines = File.read_lines("#{__DIR__}/input.txt")
template = lines.shift.chars

# Ignore blank line
lines.shift

rules = lines.to_h do |line|
  from, to = line.split(" -> ")
  { {from[0], from[1]}, to[0] }
end

10.times do
  step(template, rules)
end

counts = template.tally.values.sort
puts counts.last - counts.first

def step(template, rules)
  i = 0
  until i > template.size - 2
    chars = {template[i], template[i + 1]}
    char_to_insert = rules[chars]
    template.insert i + 1, char_to_insert
    i += 2
  end
end
