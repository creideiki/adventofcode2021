#!/usr/bin/env ruby

readings = File.read('1.input').lines.map(&:to_i)

increments = 0
win_size = 3
last = readings[0..win_size - 1].sum

1.upto(readings.size - win_size) do |i|
  win_sum = readings[i..i + win_size - 1].sum
  increments += 1 if win_sum > last
  last = win_sum
end

print increments, "\n"
