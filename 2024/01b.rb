#!/usr/bin/ruby

a1, a2 = [], []
ARGF.each_line do |line|
  n1, n2 = line.split.map(&:to_i)
  a1 << n1
  a2 << n2
end

sum = 0
a1.each do |l|
  sum += l * a2.count(l)
end

puts sum
