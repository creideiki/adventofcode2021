#!/usr/bin/env ruby

days = File.read('6.input').strip.split(",").map(&:to_i)

max_days = 256

fishes = [0] * 9

days.each { |day| fishes[day] += 1 }

1.upto(max_days) do |day|
  next_fishes = [0] * 9
  next_fishes[8] = fishes[0]
  next_fishes[7] = fishes[8]
  next_fishes[6] = fishes[7] + fishes[0]
  next_fishes[5] = fishes[6]
  next_fishes[4] = fishes[5]
  next_fishes[3] = fishes[4]
  next_fishes[2] = fishes[3]
  next_fishes[1] = fishes[2]
  next_fishes[0] = fishes[1]
  fishes = next_fishes
end

print fishes.sum, "\n"
