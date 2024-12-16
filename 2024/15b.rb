#!/usr/bin/ruby

require_relative 'grid'
require_relative 'point'
require_relative 'util'

grid = Grid.new
moves = ""
section = 0
ARGF.each_line do |line|
  if line == "\n"
    section += 1
  elsif section == 0
    line.gsub!(/#/, "##")
    line.gsub!(/O/, "[]")
    line.gsub!(/\./, "..")
    line.gsub!(/@/, "@.")
    grid << line
  else
    moves += line.chomp
  end
end

moves.each_char do |move|
  pos = grid.key('@')
  dir = Point::dir(move)
  next_q = Set[pos]
  to_move = []
  fail = false
  while !next_q.empty?
    q = next_q.to_a
    next_q = Set[]
    q.each do |pos|
      to_move.push(pos)
      next_pos = pos + dir
      if grid[next_pos] == '['
        next_q << next_pos
        next_q << next_pos + Point::E if move.in?(['^', 'v'])
      elsif grid[next_pos] == ']'
        next_q << next_pos
        next_q << next_pos + Point::W if move.in?(['^', 'v'])
      elsif grid[next_pos] == '#'
        fail = true
      end
    end
  end
  next if fail
  to_move.reverse_each do |pos|
    grid[pos + dir] = grid[pos]
    grid[pos] = '.'
  end
end

puts grid.filter_map { |p, c| 100 * p.y + p.x if c == '[' }.sum
