#!/usr/bin/env ruby

readings = File.read('1.input').lines.map(&:to_i)

increments = 0
last = readings[0]

1.upto(readings.size - 1) do |i|
  increments += 1 if readings[i] > last
  last = readings[i]
end

print increments, "\n"
