#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

antinodes = Set[]
freqs = grid.values.reject{|v| v=='.'}.uniq
freqs.each{|freq|
  points = grid.filter_map{|k,v| k if v==freq}
  points.permutation(2).each{|pair|
    antinode = pair[0] + (pair[0] - pair[1])
    antinodes << antinode if grid.key?(antinode)
  }
}

puts antinodes.size
