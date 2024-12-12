#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

seen = Set.new
dfs = lambda do |p|
  return unless seen.add?(p)

  type = grid[p]
  sides = [
    # top
    grid[p + Point::N] != type && (grid[p + Point::W] != type || grid[p + Point::NW] == type),
    # left
    grid[p + Point::W] != type && (grid[p + Point::N] != type || grid[p + Point::NW] == type),
    # bot
    grid[p + Point::S] != type && (grid[p + Point::W] != type || grid[p + Point::SW] == type),
    # right
    grid[p + Point::E] != type && (grid[p + Point::N] != type || grid[p + Point::NE] == type)
  ].count(&:itself)

  p.straight_neighbours.filter { |nb| grid[nb] == type }
   .filter_map(&dfs)
   .reduce([1, sides]) { |(a1, s1), (a2, s2)| [a1 + a2, s1 + s2] }
end

# a = area, s = sides
puts grid.keys.filter_map(&dfs).map { |a, s| a * s }.sum
