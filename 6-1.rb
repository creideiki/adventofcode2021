#!/usr/bin/env ruby

fishes = File.read('6.input').strip.split(",").map(&:to_i)

max_days = 80

1.upto(max_days) do |day|
  next_fishes = []
  fishes.each do |fish|
    if fish > 0
      next_fishes.append fish - 1
    else
      next_fishes.append 6
      next_fishes.append 8
    end
  end
  fishes = next_fishes
end

print fishes.size, "\n"
