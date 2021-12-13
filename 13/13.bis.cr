record FoldAlongX, x : Int32
record FoldAlongY, y : Int32

lines = File.read_lines("#{__DIR__}/input.txt")
empty_line_index = lines.index(&.empty?).not_nil!

dots = lines[0...empty_line_index].map do |line|
  x, y = line.split(',').map(&.to_i)
  {x, y}
end

folds =
  lines[empty_line_index + 1..].map do |instruction|
    case instruction
    when /fold along y=(\d+)/
      fold_along_y = $1.to_i
      ->(x : Int32, y : Int32) {
        if y > fold_along_y
          {x, fold_along_y*2 - y}
        else
          {x, y}
        end
      }
    when /fold along x=(\d+)/
      fold_along_x = $1.to_i
      ->(x : Int32, y : Int32) {
        if x > fold_along_x
          {fold_along_x*2 - x, y}
        else
          {x, y}
        end
      }
    else
      raise "Can't understand fold instruction: #{instruction}"
    end
  end

folds.each_with_index do |fold, i|
  dots.map! do |x, y|
    fold.call(x, y)
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
