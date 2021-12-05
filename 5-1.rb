#!/usr/bin/env ruby

require 'numo/narray'

class Map
  attr_accessor :map

  def initialize
    @size = 1
    @map = Numo::UInt8.zeros(@size, @size)
  end

  def expand(x, y)
    if x >= @size or y >= @size
      expand = [x - @size + 1, y - @size + 1].max
      @map = @map.append(Numo::UInt8.zeros(expand, @size), axis: 0)
      @map = @map.append(Numo::UInt8.zeros(@size + expand, expand), axis: 1)
      @size += expand
    end
  end

  def [](x, y)
    expand(x, y)
    @map[x, y]
  end

  def []=(x, y, val)
    expand(x, y)
    @map[x, y] = val
  end

  def mark(x1, y1, x2, y2)
    return unless x1 == x2 or y1 == y2  # Not orthogonal

    expand([x1, x2].max, [y1, y2].max)

    if x1 == x2
      y1, y2 = [y1, y2].sort
      y1.upto(y2) { |y| self[x1, y] += 1 }
    end

    if y1 == y2
      x1, x2 = [x1, x2].sort
      x1.upto(x2) { |x| self[x, y1] += 1 }
    end
  end

  def score
    Array(@map.flatten).count { |x| x > 1 }
  end

  def to_s
    "<#{self.class}:\nsize: #{@size}\n#{@map.transpose.inspect}\n>"
  end

  def inspect
    "<#{self.class}:\nsize: #{@size}\n#{@map.transpose.inspect}\n>"
  end
end

lines = File.read('5.input').lines.map(&:strip)
line_format = /(?<x1>[[:digit:]]+),(?<y1>[[:digit:]]+) -> (?<x2>[[:digit:]]+),(?<y2>[[:digit:]]+)/

map = Map.new

lines.each do |line|
  line_format.match(line) do |l|
    map.mark(l['x1'].to_i,
             l['y1'].to_i,
             l['x2'].to_i,
             l['y2'].to_i)
  end
end

print map.score, "\n"
