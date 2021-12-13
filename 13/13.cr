record FoldAlongX, x : Int32
record FoldAlongY, y : Int32

lines = File.read_lines("#{__DIR__}/input.txt")
empty_line_index = lines.index(&.empty?).not_nil!

dots = lines[0...empty_line_index].map do |line|
  x, y = line.split(',').map(&.to_i)
  {x, y}
end

instructions =
  lines[empty_line_index + 1..].map do |instruction|
    case instruction
    when /fold along y=(\d+)/
      FoldAlongY.new($1.to_i)
    when /fold along x=(\d+)/
      FoldAlongX.new($1.to_i)
    else
      raise "Can't understand fold instruction: #{instruction}"
    end
  end

instructions.each_with_index do |fold_along, i|
  dots.map! do |x, y|
    if fold_along.is_a?(FoldAlongX) && x > fold_along.x
      {fold_along.x*2 - x, y}
    elsif fold_along.is_a?(FoldAlongY) && y > fold_along.y
      {x, fold_along.y*2 - y}
    else
      {x, y}
    end
  end.uniq!

  puts "Part 1: #{dots.size}" if i == 0
end

width = dots.max_of { |x, y| x } + 1
height = dots.max_of { |x, y| y } + 1

puts "Part 2"
height.times do |y|
  width.times do |x|
    if dots.includes?({x, y})
      print '#'
    else
      print '.'
    end
  end
  puts
end
