#!/usr/bin/ruby

@values = {}
@out2ins = {}

section = 0
ARGF.map(&:chomp).each do |line|
  if line == ""
    section += 1
  elsif section == 0
    wire, init = line.split(':')
    @values[wire] = init.to_i
  else
    in1, gate, in2, out = line.split(/ -> | /)
    @out2ins[out] = [in1, gate, in2]
  end
end

def calc_value(v)
  return @values[v] if @values[v]
  in1, gate, in2 = @out2ins[v]
  @values[v] = case gate
  when 'OR'
    calc_value(in1) | calc_value(in2)
  when 'AND'
    calc_value(in1) & calc_value(in2)
  when 'XOR'
    calc_value(in1) ^ calc_value(in2)
  end
end

puts @out2ins
  .keys
  .filter_map{|v| calc_value(v) * 2**v[1..].to_i if v.start_with?('z')}
  .sum
