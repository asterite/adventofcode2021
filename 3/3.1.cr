bit_sets = File.read_lines("#{__DIR__}/input.txt")

one_counts = Array.new(bit_sets.first.size, 0)

bit_sets.each do |bits|
  bits.each_char_with_index do |bit, index|
    one_counts[index] += 1 if bit == '1'
  end
end

gamma_rate = 0
alpha_rate = 0

one_counts.each_with_index do |ones, index|
  zeros = bit_sets.size - ones

  gamma_rate <<= 1
  gamma_rate += 1 if ones > zeros

  alpha_rate <<= 1
  alpha_rate += 1 if zeros > ones
end

p! gamma_rate, alpha_rate
puts gamma_rate * alpha_rate
