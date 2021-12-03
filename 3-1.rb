#!/usr/bin/env ruby

readings = File.read('3.input').lines.map(&:strip)
word_len = readings[0].size

ones = [0] * word_len
gamma = [0] * word_len
epsilon = [0] * word_len

0.upto(word_len - 1) do |bit|
  readings.each do |reading|
    ones[bit] += reading[bit].to_i
  end

  if ones[bit] > readings.size / 2
    gamma[bit] = 1
  else
    epsilon[bit] = 1
  end
end

power = gamma.join.to_i(2) * epsilon.join.to_i(2)

print power, "\n"
