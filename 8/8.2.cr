lines = File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.split(" | ").map(&.split))

valid_inputs = Set{
  "abcefg",
  "cf",
  "acdeg",
  "acdfg",
  "bcdf",
  "abdfg",
  "abdefg",
  "acf",
  "abcdefg",
  "abcdfg",
}

result = lines.sum do |(inputs, outputs)|
  replacement_hash = ('a'..'g')
    .to_a
    .each_permutation.map do |permutation|
    ('a'..'g').to_h do |from|
      {from, permutation[from - 'a']}
    end
  end.find do |replacement_hash|
    inputs.all? do |input|
      transformed_input = replace_and_sort(input, replacement_hash)
      valid_inputs.includes?(transformed_input)
    end
  end.not_nil!

  digits = outputs.map do |output|
    transformed_output = replace_and_sort(output, replacement_hash)
    valid_inputs.index(transformed_output).not_nil!
  end

  digits.join.to_i
end

puts result

def replace_and_sort(input, replacement_hash)
  replaced_input = input.gsub(replacement_hash)
  replaced_input.chars.sort.join
end
