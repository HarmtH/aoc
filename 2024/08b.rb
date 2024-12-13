#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

antinodes = Set[]
grid.v2p.each{|freq, points|
  next if freq == '.'
  points.permutation(2).each{|p1, p2|
    antinode = p1
    diff = p1 - p2
    while grid.key?(antinode)
      antinodes << antinode
      antinode += diff
    end
  }
}

puts antinodes.size
