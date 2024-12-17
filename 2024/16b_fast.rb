#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'
require_relative 'heap'

grid = Grid.new
ARGF.each_line do |line|
  grid << line
end

scores = {}
queue = Heap.new { |lhs, rhs| lhs[0] < rhs[0] }
queue << [0, [grid.key('S'), Point::E]]

while (score, (point, dir) = queue.pop)
  next if scores.has_key?([point, dir])
  scores[[point, dir]] = score
  queue << [score + 1, [point + dir, dir]] if grid[point + dir] != '#'
  queue << [score + 1000, [point, dir * :left]]
  queue << [score + 1000, [point, dir * :right]]
end

# get all [end tile, end direction] pairs with lowest score
bt_queue = Point::STRAIGHT_DIRS.map { |dir| [grid.key('E'), dir] }
                               .group_by { |pd| scores[pd] }.min.last

# trace all lowest scoring paths from end tile back to start tile
best_pds = Set[]
while (point, dir = bt_queue.pop)
  next unless best_pds.add?([point, dir])
  score = scores[[point, dir]]
  bt_queue << [point - dir, dir] if scores[[point - dir, dir]] == score - 1
  bt_queue << [point, dir * :left] if scores[[point, dir * :left]] == score - 1000
  bt_queue << [point, dir * :right] if scores[[point, dir * :right]] == score - 1000
end

puts best_pds.map{ |point, dir| point}.uniq.size
