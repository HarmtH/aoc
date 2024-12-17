#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'
require_relative 'heap'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

scores = {:best_points => Set[], :finished => Float::INFINITY}
queue = Heap.new { |lhs, rhs| lhs[0] < rhs[0] } 
queue << [0, [[grid.key('S')], Point::E]]

puts (while (score, (points, dir) = queue.pop)
  next if score > (scores[[points.last, dir]] ||= score)
  break scores[:best_points].size if score > scores[:finished]
  scores[:finished] = score if grid[points.last] == 'E'
  scores[:best_points].merge(points) if grid[points.last] == 'E' 
  queue << [score + 1, [points + [points.last + dir], dir]] if grid[points.last + dir] != '#'
  queue << [score + 1000, [points, dir * :left]]
  queue << [score + 1000, [points, dir * :right]]
end)
