#!/usr/bin/ruby

class Integer
  def |(rhs)
    (self.to_s + rhs.to_s).to_i
  end
end

puts ARGF
  .each_line
  .map{|line|
    test_value, remaining_numbers = line.split(":")
    [test_value.to_i, remaining_numbers.split.map(&:to_i)]}
  .filter_map{|test_value, remaining_numbers|
    test_value if [:+, :*, :|]
      .repeated_permutation(remaining_numbers.size - 1)
      .any?{|ops|
        test_value == ops
          .zip(remaining_numbers[1..])
          .reduce(remaining_numbers[0]) {|res, op|
            res.send(*op)}}}
  .sum
