#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

seen = Set[]
dfs = lambda do |pt|
  return unless seen.add?(pt)

  same_type_nbs = pt.straight_neighbours.filter { |nb| grid[nb] == grid[pt] }
  perim = 4 - same_type_nbs.size
  same_type_nbs
    .filter_map(&dfs)
    # Abuse Point class to store area and perimeter
    .reduce(Point[1, perim], :+)
end

# p.y = area, p.x = perimeter
puts grid.keys.filter_map(&dfs).map { |p| p.y * p.x }.sum
