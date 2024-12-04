#!/usr/bin/ruby

require_relative 'point'

grid = []
ARGF.each_line do |line|
  grid << line
end

sum = 0
Point::each_on(grid) do |p|
  Point::NEIGHBOURS.each do |dp|
    np = p
    good = true
    "XMAS".each_char do |c|
      good &= np.on(grid) == c
      np += dp
    end
    good && sum += 1
  end
end

puts sum
