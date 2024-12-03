#!/usr/bin/ruby

sum = 0
ARGF.each_line do |line|
  reallvls = line.split.map(&:to_i)
  realsafe = false
  (0...reallvls.length+1).each do |i|
    lvls = reallvls.clone
    if i != reallvls.length
      lvls.delete_at(i)
    end
    incr = lvls[1] > lvls[0]
    safe = true
    lvls.each_cons(2) do |lvl|
      d = (lvl[1] - lvl[0])
      safe &= (incr && d > 0) || (!incr && d < 0)
      safe &= (d.abs <= 3)
    end
    realsafe |= safe
  end
  realsafe && sum += 1
end

puts sum
