#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

sum = 0
grid.each_key do |p|
  Point::NEIGHBOURS.each do |dp|
    np = p
    good = true
    "XMAS".each_char do |c|
      good &= grid[np] == c
      np += dp
    end
    good && sum += 1
  end
end

puts sum
