#!/usr/bin/ruby

schematic = nil
type = nil
keys = []
locks = []

ARGF.map(&:chomp).each.with_index do |line, lineno|
  if (lineno % 8) == 0
    type = (line[0] == '#') ? :lock : :key
    schematic = [0] * 5
  elsif (lineno % 8) == 6
    (type == :lock ? locks : keys) << schematic
  else
    line.each_char.with_index{|c, i| schematic[i] += 1 if c == '#'}
  end
end

puts keys
  .product(locks)
  .filter{|key, lock| key
    .zip(lock)
    .map(&:sum)
    .all?{|sum| sum <= 5}}
  .count
