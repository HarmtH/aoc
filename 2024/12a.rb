#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

seen = Set.new
dfs = -> (p) do
  return unless seen.add?(p)
  same_nbs = p.straight_neighbours.filter{|q| grid[p] == grid[q]}
  perim = 4 - same_nbs.size
  same_nbs
    .filter_map(&dfs)
    .reduce([1, perim]){ |(s1, p1), (s2, p2)| [s1 + s2, p1 + p2] }
end

puts grid.keys.reduce(0) { |sum, p|
  seen.include?(p) ? sum : sum + dfs.(p).reduce(:*)
}
