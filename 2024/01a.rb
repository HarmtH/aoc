#!/usr/bin/ruby

a1, a2 = [], []
ARGF.each_line do |line|
  n1, n2 = line.split.map(&:to_i)
  a1 << n1
  a2 << n2
end

a1.sort!
a2.sort!

sum = 0
for i in 0...a1.length
  sum += (a1[i] - a2[i]).abs
end

puts sum
