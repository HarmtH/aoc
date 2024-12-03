#!/usr/bin/ruby

sum = 0
enabled = true
ARGF.each_line do |line|
  line.scan(/don't|do|mul\((\d{1,3}),(\d{1,3})\)/) do 
    match = Regexp.last_match
    if match[0] == "do"
      enabled = true
    elsif match[0] == "don't"
      enabled = false
    elsif enabled
      sum += match[1].to_i * match[2].to_i
    end
  end
end

puts sum
