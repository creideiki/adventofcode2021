#!/usr/bin/env ruby

crabs = File.read('7.input').strip.split(",").map(&:to_i)

leftmost = crabs.min
rightmost = crabs.max

cost = [0] * (rightmost + 1)

leftmost.upto(rightmost) do |gather|
  cost[gather] = (crabs.map { |crab| (gather - crab).abs }).sum
end

print cost.min, "\n"
