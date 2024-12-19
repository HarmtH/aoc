#!/usr/bin/ruby

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

def check(subdesign, patterns)
  return true if subdesign.empty?
  patterns.any? { |pattern| subdesign.start_with?(pattern) &&
    check(subdesign[pattern.size..], patterns) }
end
    
puts todo.filter { |design| check(design, patterns) }.count
