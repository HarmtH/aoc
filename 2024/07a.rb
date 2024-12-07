#!/usr/bin/ruby

sum = 0
ARGF.each_line do |line|
  test_value, remaining_numbers = line.split(":")
  test_value = test_value.to_i
  remaining_numbers = remaining_numbers.split.map(&:to_i)
  sum += test_value if
    [:+, :*].repeated_permutation(remaining_numbers.size - 1).any?{|ops|
      test_value == remaining_numbers[1..].zip(ops)
        .reduce(remaining_numbers[0]){|res, (val, op)| res.send(op, val)}
    }
end

puts sum
