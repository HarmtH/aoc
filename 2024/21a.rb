#!/usr/bin/ruby

require './grid'
require './point'
require './util'

@numpad = Grid.new(str2num: false)
@numpad << "789"
@numpad << "456"
@numpad << "123"
@numpad << " 0A"

@dirpad = Grid.new
@dirpad << " ^A"
@dirpad << "<v>"

memoize def calc_presses(topad, topresses, robots)
  return topresses.size if robots == 0
  total = 0
  pos = topad.key('A')
  topresses.each_char do |topress|
    move = topad.key(topress) - pos
    results = []
    if topad[pos + Point[move.y, 0]] != ' '
      results << (move.y < 0 ? '^' : 'v') * move.y.abs + (move.x < 0 ? '<' : '>') * move.x.abs + 'A'
    end
    if topad[pos + Point[0, move.x]] != ' '
      results << (move.x < 0 ? '<' : '>') * move.x.abs + (move.y < 0 ? '^' : 'v') * move.y.abs + 'A'
    end
    total += results.map{|result| calc_presses(@dirpad, result, robots - 1)}.min
    pos += move
  end
  total
end

puts (ARGF.map(&:chomp).map do |line|
  calc_presses(@numpad, line, 3) * line.to_i
end).sum
