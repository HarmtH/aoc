#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

dfs = -> (p) {
  return 1 if grid[p] == 9
  (p.straight_neighbours & grid.v2p[grid[p] + 1]).map(&dfs).sum
}

puts grid.v2p[0].map(&dfs).sum
