bit_sets = File.read_lines("#{__DIR__}/input.txt")

ogr_rating = compute_rating(bit_sets) do |ones, zeros|
  ones.size >= zeros.size ? ones : zeros
end

co2_rating = compute_rating(bit_sets) do |ones, zeros|
  ones.size < zeros.size ? ones : zeros
end

p! ogr_rating, co2_rating
puts ogr_rating * co2_rating

def compute_rating(bit_sets)
  bit_sets = bit_sets.dup

  index = 0

  until bit_sets.size == 1
    ones, zeros = bit_sets.partition { |bits| bits[index] == '1' }
    bit_sets = yield ones, zeros

    index = (index + 1) % bit_sets.first.size
  end

  bit_sets.first.to_i(2)
end
