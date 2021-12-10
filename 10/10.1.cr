record Valid
record Incomplete
record Corrupted, illegal_char : Char

alias ChunkStatus = Valid | Incomplete | Corrupted

OPENING_CHARS = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}

chunks = File.read_lines("#{__DIR__}/input.txt")
char_points = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

puts chunks
  .map { |chunk| process_chunk(chunk) }
  .select(Corrupted)
  .map(&.illegal_char)
  .sum { |char| char_points[char] }

def process_chunk(chunk : String) : ChunkStatus
  stack = [] of Char

  chunk.each_char do |char|
    case char
    when '(', '[', '{', '<'
      stack.push(char)
    when ')', ']', '}', '>'
      stack_top = stack.pop
      if OPENING_CHARS[char] != stack_top
        return Corrupted.new char
      end
    else
      raise "Unexpected char found: #{char}"
    end
  end

  if stack.empty?
    Valid.new
  else
    Incomplete.new
  end
end
