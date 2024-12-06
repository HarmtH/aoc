#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

sum = 0
grid.each_key do |p|
  next unless grid[p] == "A"

  nw = grid[p + Point::NW]
  se = grid[p + Point::SE]
  next unless (nw == "M" && se == "S") || (nw == "S" && se == "M")

  ne = grid[p + Point::NE]
  sw = grid[p + Point::SW]
  next unless (ne == "M" && sw == "S") || (ne == "S" && sw == "M")

  sum += 1
end

puts sum
