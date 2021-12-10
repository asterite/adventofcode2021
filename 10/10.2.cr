record Valid
record Incomplete, chars : Array(Char)
record Corrupted, illegal_char : Char

alias ChunkStatus = Valid | Incomplete | Corrupted

OPENING_CHARS = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}

CLOSING_CHARS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>',
}

chunks = File.read_lines("#{__DIR__}/input.txt")
char_points = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4,
}

scores = chunks
  .map { |chunk| process_chunk(chunk) }
  .select(Incomplete)
  .map(&.chars)
  .map do |chars|
    score = 0_i64
    chars.reverse_each do |char|
      score *= 5
      score += char_points[CLOSING_CHARS[char]]
    end
    score
  end

scores.sort!
puts scores[scores.size // 2]

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
    Incomplete.new(stack)
  end
end
