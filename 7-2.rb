#!/usr/bin/env ruby

crabs = File.read('7.input').strip.split(",").map(&:to_i)

leftmost = crabs.min
rightmost = crabs.max

cost = [0] * (rightmost + 1)

leftmost.upto(rightmost) do |gather|
  cost[gather] = (crabs.map do |crab|
                    n = (gather - crab).abs
                    (n / 2.0 * (1 + n)).to_i
                  end).sum
end

print cost.min, "\n"
