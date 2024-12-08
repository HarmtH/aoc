#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end
v2p = grid.tov2p

antinodes = Set[]
v2p.each{|freq, points|
  next if freq == '.'
  points.permutation(2).each{|p1, p2|
    antinode = p1 + (p1 - p2)
    antinodes << antinode if grid.key?(antinode)
  }
}

puts antinodes.size
