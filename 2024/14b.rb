#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new(multi: true)
ARGF.each_line do |line|
  x1, y1, vx1, vy1 = line.scan(/-?\d+/).map(&:to_i)
  grid[Point[y1, x1]] << Point[vy1, vx1]
end

puts (0..).filter_map { |i|
  break i if grid.filter{ |p, v| p.y == 23 && p.x in (36...67) }.count == 31
  new_grid = Grid.new(multi: true, ys: grid.ys, xs: grid.xs)
  grid.each_multi{ |p, v| new_grid[(p + v) % grid] << v }
  grid = new_grid
}
