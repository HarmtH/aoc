#!/usr/bin/ruby

e2l = {}
updates = []
section = 0
ARGF.each_line do |line|
  line == "\n" && (section += 1) && next
  if section == 0
    kv = line.split("|").map(&:to_i)
    (e2l[kv.first] ||= []) << kv.last
  elsif
    updates << line.split(",").map(&:to_i)
  end
end

sum = 0
updates.each do |update|
  repaired = []
  update.each do |e|
    newloc = repaired.index{|l| e2l[e]&.include?(l)} || -1
    repaired.insert(newloc, e)
  end
  if update != repaired
    sum += repaired[repaired.length / 2]
  end
end

puts sum
