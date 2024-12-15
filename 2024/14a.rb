#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new(multi: true)
ARGF.each_line do |line|
  x1, y1, vx1, vy1 = line.scan(/-?\d+/).map(&:to_i)
  grid[Point[y1, x1]] << Point[vy1, vx1]
end

100.times do |x|
  new_grid = Grid.new(multi: true, ys: grid.ys, xs: grid.xs)
  grid.each_multi{ |p, v| new_grid[(p + v) % grid] << v }
  grid = new_grid
end

q1 = grid.each_multi.filter{ |p, v| p.y < grid.ys / 2 && p.x > grid.xs / 2 }.count
q2 = grid.each_multi.filter{ |p, v| p.y < grid.ys / 2 && p.x < grid.xs / 2 }.count
q3 = grid.each_multi.filter{ |p, v| p.y > grid.ys / 2 && p.x < grid.xs / 2 }.count
q4 = grid.each_multi.filter{ |p, v| p.y > grid.ys / 2 && p.x > grid.xs / 2 }.count

puts q1 * q2 * q3 * q4
