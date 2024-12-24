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

prevres = ""
puts ((2..).each do |i|
  res = nil
  computers.each do |computer|
    connections[computer].combination(i) do |conns|
      if conns.combination(2).all? { |conn1, conn2| connections[conn1].include?(conn2) }
        res = [computer, *conns].sort.join(',') 
        break
      end
    end
    break if res
  end
  break prevres if not res
  prevres = res
end)
