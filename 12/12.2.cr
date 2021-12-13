require "colorize"

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
visited_small_cave_twice = false
current_path = [] of String
find_paths(
  "start",
  connections,
  visited,
  visited_small_cave_twice,
  current_path,
  paths,
)

paths.each do |path|
  puts path.join(',')
end
puts paths.size

def find_paths(from, connections, visited, visited_small_cave_twice, current_path, paths)
  small_cave = from[0].lowercase?

  next_visited = [*visited]
  next_visited_small_cave_twice = visited_small_cave_twice

  if small_cave
    visited_from = visited.includes?(from)
    return if visited_from && from == "start"

    if visited_from
      return if visited_small_cave_twice

      next_visited_small_cave_twice = true
    else
      next_visited << from
    end
  end

  current_path.push(from)

  connections[from].each do |to|
    if to == "end"
      paths << [*current_path, "end"]
    else
      find_paths(
        to,
        connections,
        next_visited,
        next_visited_small_cave_twice,
        current_path,
        paths,
      )
    end
  end

  current_path.pop
end
