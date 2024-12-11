#!/usr/bin/ruby

# n2a = (stone) number to amount (of that stone number)
n2a = Hash.new(0)

ARGF.each_line.first.split.each { |num| n2a[num.to_i] += 1 }

25.times do
  new_n2a = Hash.new(0)
  n2a.each do |n, a|
    if n == 0
      new_n2a[1] += a
    elsif (len = n.to_s.length).even?
      new_n2a[n.to_s[0...len / 2].to_i] += a
      new_n2a[n.to_s[len / 2..].to_i] += a
    else
      new_n2a[n * 2024] += a
    end
  end
  n2a = new_n2a
end

puts n2a.values.sum
