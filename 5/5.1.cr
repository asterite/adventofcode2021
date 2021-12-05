lines = File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.split(" -> "))
  .map(&.map(&.split(',').map(&.to_i)))

counts = Hash({Int32, Int32}, Int32).new(0)

lines.each do |(start, stop)|
  x1, y1 = start
  x2, y2 = stop

  if x1 == x2
    y1.to(y2) do |y|
      counts[{x1, y}] += 1
    end
  end

  if y1 == y2
    x1.to(x2) do |x|
      counts[{x, y1}] += 1
    end
  end
end

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
