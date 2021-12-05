lines = File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.split(" -> "))
  .map(&.map(&.split(',').map(&.to_i)))

counts = Hash({Int32, Int32}, Int32).new(0)

lines.each do |(start, stop)|
  x1, y1 = start
  x2, y2 = stop

  x_range =
    if x1 == x2
      Iterator.of(x1)
    else
      x1.to(x2)
    end

  y_range =
    if y1 == y2
      Iterator.of(y1)
    else
      y1.to(y2)
    end

  x_range.zip(y_range).to_a.each do |x, y|
    counts[{x, y}] += 1
  end
end

# show_counts(counts)

count = counts.count { |(x, y), count| count > 1 }
puts count

def show_counts(counts)
  10.times do |y|
    10.times do |x|
      count = counts[{x, y}]
      if count == 0
        print '.'
      else
        print count
      end
    end
    puts
  end
end
