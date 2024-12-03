#!/usr/bin/ruby

sum = 0
ARGF.each_line do |line|
  mulslist = line.scan(/mul\((\d{1,3}),(\d{1,3})\)/)
  mulslist.each do |muls|
    sum += muls[0].to_i * muls[1].to_i
  end
end

puts sum
