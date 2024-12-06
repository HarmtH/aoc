#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

sum = 0
grid.each_key do |o|
  next if grid[o] != '.'

  ng = grid.clone
  ng[o] = '#'
  guard = ng.key('^')
  dir = Point::N
  seen = Set[]
  loop = -> { seen.include?([guard, dir]) }

  while ng.key?(guard) && !loop.()
    seen << [guard, dir]
    while ng[guard + dir] == '#'
      dir *= :right
    end
    guard += dir
  end

  sum += 1 if loop.()
end

puts sum
