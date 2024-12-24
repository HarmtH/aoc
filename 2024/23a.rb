#!/usr/bin/ruby

computers = Set[]
connections = Hash.new{|h, k| h[k] = []}
ARGF.map(&:chomp).each do |line|
  a, b = line.split('-')
  computers << a
  computers << b
  connections[a] << b
  connections[b] << a
end

sets3 = Set[]
computers.each do |computer|
  connections[computer].combination(2).each do |conn1, conn2|
    sets3 << [computer, conn1, conn2].sort if connections[conn1].include?(conn2)
  end
end

puts sets3.filter{ |set3| set3.any? { |computer| computer.start_with?('t') } }.count
