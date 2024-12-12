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

  same_type_nbs = pt.straight_neighbours.filter { |nb| grid[nb] == grid[pt] }
  perim = 4 - same_type_nbs.size
  same_type_nbs
    .filter_map(&dfs)
    .reduce([1, perim]) { |(a1, p1), (a2, p2)| [a1 + a2, p1 + p2] }
end

# a = area, p = perimeter
puts grid.keys.filter_map(&dfs).map { |a, p| a * p }.sum
