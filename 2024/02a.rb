#!/usr/bin/ruby

sum = 0
ARGF.each_line do |line|
  lvls = line.split.map(&:to_i)
  incr = lvls[1] > lvls[0]
  safe = true
  lvls.each_cons(2) do |lvl|
    d = (lvl[1] - lvl[0])
    safe &= (incr && d > 0) || (!incr && d < 0)
    safe &= (d.abs <= 3)
  end
  safe && sum += 1
end

puts sum
