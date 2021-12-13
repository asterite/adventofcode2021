connections = Hash(String, Array(String)).new do |h, k|
  h[k] = [] of String
end

File
  .read_lines("#{__DIR__}/input.txt")
  .map(&.split('-'))
  .each do |(from, to)|
    connections[from] << to
    connections[to] << from
  end

paths = [] of Array(String)
visited = Set(String).new
current_path = [] of String
find_paths("start", connections, visited, current_path, paths)

paths.each do |path|
  puts path.join(',')
end
puts paths.size

def find_paths(from, connections, visited, current_path, paths)
  small_cave = from[0].lowercase?
  return if small_cave && visited.includes?(from)

  next_visited = visited.dup
  next_visited << from if small_cave

  current_path.push(from)

  connections[from].each do |to|
    if to == "end"
      paths << [*current_path, "end"]
    else
      find_paths(to, connections, next_visited, current_path, paths)
    end
  end

  current_path.pop
end
