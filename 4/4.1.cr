alias Position = {Int32, Int32}

record Cell, number : Int32, marked : Bool do
  def mark
    Cell.new(number, true)
  end
end

lines = File.read_lines("#{__DIR__}/input.txt")

chunks = lines.each.slice_before { |line| line.empty? }.to_a
called_out_numbers = chunks.shift.first.split(',').map(&.to_i)

chunks.each(&.shift)

boards = chunks.map do |board_lines|
  rows = board_lines.map { |line| line.split.map(&.to_i) }

  board = {} of Position => Cell
  rows.each_with_index do |row, y|
    row.each_with_index do |number, x|
      board[{x, y}] = Cell.new(number: number, marked: false)
    end
  end
  board
end

called_out_numbers.each do |number|
  boards.each do |board|
    mark(board, number)
  end

  puts "Called out number: #{number}"
  boards.each do |board|
    puts "-" * 29
    pretty_print(board)
    puts "-" * 29
    puts
  end

  winner_board = boards.find { |board| winner?(board) }
  if winner_board
    pp winner_board
    puts score(winner_board, number)
    break
  end
end

def mark(board, called_out_number)
  board.each do |(x, y), cell|
    if cell.number == called_out_number
      board[{x, y}] = cell.mark
      break
    end
  end
end

def winner?(board)
  # Check if any row is all marked
  winner_by_column = 5.times.any? do |y|
    5.times.all? { |x| board[{x, y}].marked }
  end
  return true if winner_by_column

  # Check if any column is all marked
  winner_by_row = 5.times.any? do |x|
    5.times.all? { |y| board[{x, y}].marked }
  end
  return true if winner_by_row

  false
end

def score(board, last_number)
  sum = board
    .select { |(x, y), cell| !cell.marked }
    .sum { |(x, y), cell| cell.number }

  sum * last_number
end

def pretty_print(board)
  5.times do |y|
    5.times do |x|
      cell = board[{x, y}]
      print cell.number.to_s.rjust(2)
      if cell.marked
        print "(x)"
      else
        print "( )"
      end
      print " "
    end
    puts
  end
end
