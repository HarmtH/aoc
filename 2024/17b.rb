#!/usr/bin/ruby

def check(a, cmp)
  b = (a & 0b111) ^ 0b010
  c = (a >> b) & 0b111
  b ^ c ^ 0b011 == cmp
end

def calc(value, pos, program)
  (value ... value + 8)
    .filter{|v| check(v, program[pos])}
    .filter_map{|v| pos == 0 \
      ? v
      : calc(v << 3, pos - 1, program)}
    .first
end

program = [2,4,1,2,7,5,4,5,1,3,5,5,0,3,3,0]
puts calc(0, program.size - 1, program)
