#!/usr/bin/ruby

def check(a, subprogram)
  subprogram.size.times do |i|
    b = (a & 0b111) ^ 0b010
    c = (a >> b) & 0b111
    b = b ^ c ^ 0b011
    return false if subprogram[i] != b
    a = a >> 3
  end
  true
end

def calc(value, pos, program)
  return value if pos == 0
  8.times do |i|
    next if !check(value + i, program[pos..])
    r = calc((value + i) << 3, pos - 1, program)
    return r if r
  end
  false
end

puts calc(0, 15, [2,4,1,2,7,5,4,5,1,3,5,5,0,3,3,0])
