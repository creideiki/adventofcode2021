#!/usr/bin/env ruby

class Polymer
  attr_accessor :molecule
  attr_accessor :rules

  def initialize(template)
    @molecule = template
    @rules = Hash.new ''
  end

  def add_rule(pair, insert)
    @rules[pair] = insert
  end

  def step
    new_molecule = @molecule[0]
    (@molecule.size - 1).times do |pos|
      pair = @molecule[pos, 2]
      new_molecule += @rules[pair] + pair[1]
    end
    @molecule = new_molecule
  end

  def score
    counts = Hash.new 0
    @molecule.each_char do |atom|
      counts[atom] += 1
    end
    l = counts.values.sort
    l[-1] - l[0]
  end

  def to_s
    "<#{self.class}: #{@molecule}>"
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

10.times do
  p.step
end

print p.score, "\n"
