#!/usr/bin/ruby

require 'matrix'

M = Matrix.zero(2)
puts ARGF.each_line.with_index.map { |line, idx|
  idx %= 4
  tokens = 0
  case idx
  when 0
    M[0, 0], M[1, 0] = line.scan(/\d+/).map(&:to_i)
  when 1
    M[0, 1], M[1, 1] = line.scan(/\d+/).map(&:to_i)
  when 2
    b = Vector[*line.scan(/\d+/).map(&:to_i)]
    b += Vector[1, 1] * 10_000_000_000_000
    sol = M.lup.solve(b)
    tokens = (3 * sol[0] + sol[1]).to_i if sol.all? { |x| x == x.to_i }
  end
  tokens
}.sum
