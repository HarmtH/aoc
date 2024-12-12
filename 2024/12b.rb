#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

seen = Set.new
dfs = lambda do |pt|
  return unless seen.add?(pt)

  type = grid[pt]
  sides = [
    # top
    grid[pt + Point::N] != type && (grid[pt + Point::W] != type || grid[pt + Point::NW] == type),
    # left
    grid[pt + Point::W] != type && (grid[pt + Point::N] != type || grid[pt + Point::NW] == type),
    # bot
    grid[pt + Point::S] != type && (grid[pt + Point::W] != type || grid[pt + Point::SW] == type),
    # right
    grid[pt + Point::E] != type && (grid[pt + Point::N] != type || grid[pt + Point::NE] == type)
  ].count(&:itself)

  pt.straight_neighbours
   .filter { |nb| grid[nb] == type }
   .filter_map(&dfs)
   .reduce([1, sides]) { |(a1, s1), (a2, s2)| [a1 + a2, s1 + s2] }
end

# a = area, s = sides
puts grid.keys.filter_map(&dfs).map { |a, s| a * s }.sum
