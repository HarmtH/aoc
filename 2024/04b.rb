#!/usr/bin/ruby

require_relative 'point'

grid = []
ARGF.each_line do |line|
  grid << line
end

sum = 0
Point::each_on(grid) do |p|
  next unless p.on(grid) == "A"

  nw = (p + Point::NW).on(grid)
  se = (p + Point::SE).on(grid)
  next unless (nw == "M" && se == "S") || (nw == "S" && se == "M")

  ne = (p + Point::NE).on(grid)
  sw = (p + Point::SW).on(grid)
  next unless (ne == "M" && sw == "S") || (ne == "S" && sw == "M")

  sum += 1
end

puts sum
