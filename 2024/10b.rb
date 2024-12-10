#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

def dfs(grid, p)
  return 1 if grid[p] == 9
  (p.straight_neighbours & grid.v2p[grid[p] + 1]).map{|p| dfs(grid, p)}.sum
end

puts grid.v2p[0].map{|p| dfs(grid, p)}.sum
