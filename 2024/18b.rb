#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'
require_relative 'heap'

def score(grid)
  seen = Set[]
  queue = Heap.new { |lhs, rhs| lhs[0] < rhs[0] }
  queue << [0, Point[0,0]]

  while (score, point = queue.pop) do
    next unless seen.add?(point)
    return score if point == Point[grid.ys - 1, grid.xs - 1]
    Point::STRAIGHT_DIRS
      .map { |dir| point + dir }
      .filter{ |p| grid.valid?(p) && !grid.has_key?(p) }
      .each{ |p| queue << [score + 1, p] }
  end
end

grid = Grid.new(xs: 71, ys: 71)
ARGF.each_line do |line|
  x, y = line.scan(/\d+/).map(&:to_i)
  grid[Point[y, x]] = '#'

  if !score(grid)
    puts "#{x},#{y}"
    break
  end
end
