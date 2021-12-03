#!/usr/bin/env ruby

readings = File.read('3.input').lines.map(&:strip)
word_len = readings[0].size

oxygen = readings.dup
co2 = readings.dup

0.upto(word_len - 1) do |bit|
  if oxygen.size > 1
    ones = 0
    most_common = 0
    oxygen.each do |o|
      ones += o[bit].to_i
    end
    most_common = 1 if ones >= (oxygen.size / 2.0).ceil
    oxygen.delete_if { |o| o[bit].to_i != most_common }
  end

  if co2.size > 1
    ones = 0
    most_common = 0
    co2.each do |c|
      ones += c[bit].to_i
    end
    most_common = 1 if ones >= (co2.size / 2.0).ceil
    co2.delete_if { |c| c[bit].to_i == most_common }
  end
end

life_support = oxygen[0].to_i(2) * co2[0].to_i(2)

print life_support, "\n"
