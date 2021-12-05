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

  winner_boards = boards.select { |board| winner?(board) }
  last_winner_boards = winner_boards

  winner_boards.each do |winner_board|
    boards.delete(winner_board)
  end

  if boards.empty?
    puts score(last_winner_boards.first, number)
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
