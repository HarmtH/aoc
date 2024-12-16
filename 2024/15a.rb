#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'

grid = Grid.new
moves = ""
section = 0
ARGF.each_line do |line|
  if line == "\n"
    section += 1
  elsif section == 0
    grid << line
  else
    moves += line.chomp
  end
end

moves.each_char do |move|
  pos = grid.key('@')
  dir = Point::dir(move)
  to_move = [pos]
  while grid[pos += dir] == 'O'
    to_move << pos
  end
  next if grid[pos] == '#'
  to_move.reverse_each do |pos|
    grid[pos + dir] = grid[pos]
    grid[pos] = '.'
  end
end

puts grid.filter_map { |p, c| 100 * p.y + p.x if c == 'O' }.sum
