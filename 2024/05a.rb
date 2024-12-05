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

puts updates
  .filter{|update|
    update.each_with_index.all?{|e, idx|
      update[0...idx].none?{|l|
        e2l[e]&.include?(l)}}}
  .map{|update|
    update[update.length / 2]}
  .sum
