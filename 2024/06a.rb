#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

guard = grid.key('^')
dir = Point::N

while grid.key?(guard)
  grid[guard] = 'X'
  while grid[guard + dir] == '#'
    dir *= :right
  end
  guard += dir
end

puts grid.select{|k,v| v=='X'}.size
