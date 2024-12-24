#!/usr/bin/ruby

def next_secret(num)
  num = ((num * 64) % 16777216) ^ num
  num = (num / 32) ^ num
  ((num * 2048) % 16777216) ^ num
end

def prices(init)
  return to_enum(:prices, init) unless block_given?
  loop { yield init % 10; init = next_secret(init) }
end

c2b = Hash.new(0)
ARGF.each_line do |line|
  seen = Set[]
  price_and_diffs = prices(line.to_i).each_cons(2).take(2000).map{|p1, p2| [p2, p2 - p1]}
  price_and_diffs.each_cons(4) do |(_, d1), (_, d2), (_, d3), (p4, d4)|
    c2b[[d1, d2, d3, d4]] += p4 if seen.add?([d1, d2, d3, d4])
  end
end

puts c2b.values.max
