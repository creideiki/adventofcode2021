#!/usr/bin/env ruby

class Polymer
  attr_accessor :pairs
  attr_accessor :rules

  def initialize(template)
    @pairs = Hash.new 0
    @rules = {}
    @trail = template[-1]

    (template.size - 1).times do |pos|
      pair = template[pos, 2]
      @pairs[pair] += 1
    end
  end

  def add_rule(pair, insert)
    @rules[pair] = insert
  end

  def step
    new_pairs = Hash.new 0
    @pairs.each do |pair, count|
      if production = @rules[pair]
        new_pairs[pair[0] + production] += count
        new_pairs[production + pair[1]] += count
      else
        new_pairs[pair] = count
      end
    end
    @pairs = new_pairs
  end

  def score
    counts = Hash.new 0
    @pairs.each { |pair, count| counts[pair[0]] += count }
    counts[@trail] += 1

    l = counts.values.sort
    l[-1] - l[0]
  end

  def size
    @pairs.values.sum + 1
  end

  def to_s
    "<#{self.class}>"
  end

  def inspect
    to_s
  end
end

insertion_format = /^(?<pair>[[:upper:]]{2}) -> (?<insert>[[:upper:]])$/

input = File.read('14.input').lines.map(&:strip)

p = Polymer.new input.shift

input.shift

input.each do |line|
  insertion = insertion_format.match line
  p.add_rule insertion['pair'], insertion['insert']
end

40.times do
  p.step
end

print p.score, "\n"
