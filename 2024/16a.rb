#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'
require_relative 'heap'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

seen = Set[]
queue = Heap.new { |lhs, rhs| lhs[0] < rhs[0] }
queue << [0, [grid.key('S'), Point::E]]

puts (while (score, (point, dir) = queue.pop)
  next unless seen.add?([point, dir])
  break score if grid[point] == 'E'
  queue << [score + 1, [point + dir, dir]] if grid[point + dir] != '#'
  queue << [score + 1000, [point, dir * :left]]
  queue << [score + 1000, [point, dir * :right]]
end)
