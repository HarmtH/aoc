#!/usr/bin/ruby

require './util.rb'

patterns = nil
todo = []

section = 0
ARGF.map(&:chomp).each do |line|
  if line == ""
    section += 1
  elsif section == 0
    patterns = line.split(", ")
  else
  todo << line
  end
end

memoize def check(subdesign, patterns)
  return 1 if subdesign.empty?
  patterns.filter_map { |pattern| subdesign.start_with?(pattern) &&
    check(subdesign[pattern.size..], patterns) }.sum
end
    
puts todo.map { |design| check(design, patterns) }.sum
