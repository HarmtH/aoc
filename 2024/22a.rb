#!/usr/bin/ruby

require './util.rb'

def next_secret(num)
  num = ((num * 64) % 16777216) ^ num
  num = (num / 32) ^ num
  ((num * 2048) % 16777216) ^ num
end

def buyer(init)
  return to_enum(:buyer, init) unless block_given?
  loop { yield init; init = next_secret(init) }
end

puts ARGF.map{|line| buyer(line.to_i).at(2001)}.sum
