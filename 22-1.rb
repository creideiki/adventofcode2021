#!/usr/bin/env ruby

require 'numo/narray'

class Reactor
  attr_accessor :map

  def initialize
    @map = Numo::UInt8.zeros(101, 101, 101)
  end

  def outside?(c1, c2)
    (c1 < -50 and c2 < -50) or
      (c1 > 50 and c2 > 50)
  end

  def mark(set, x1, x2, y1, y2, z1, z2)
    xmin, xmax = [x1, x2].sort
    ymin, ymax = [y1, y2].sort
    zmin, zmax = [z1, z2].sort
    return if outside?(xmin, xmax) or outside?(ymin, ymax) or outside?(zmin, zmax)

    xmin.upto(xmax) do |x|
      ymin.upto(ymax) do |y|
        zmin.upto(zmax) do |z|
          @map[x + 50, y + 50, z + 50] = set ? 1 : 0
        end
      end
    end
  end

  def score
    @map.sum
  end

  def to_s
    "<#{self.class}:\n#{@map.inspect}\n>"
  end

  def inspect
    to_s
  end
end

lines = File.read('22.input').lines.map(&:strip)
line_format = /^(?<set>on|off) x=(?<x1>[[:digit:]\-]+)..(?<x2>[[:digit:]\-]+),y=(?<y1>[[:digit:]\-]+)..(?<y2>[[:digit:]\-]+),z=(?<z1>[[:digit:]\-]+)..(?<z2>[[:digit:]\-]+)$/

reactor = Reactor.new

lines.each do |line|
  line_format.match(line) do |l|
    mark = (l['set'] == 'on')
    reactor.mark(mark,
                 l['x1'].to_i,
                 l['x2'].to_i,
                 l['y1'].to_i,
                 l['y2'].to_i,
                 l['z1'].to_i,
                 l['z2'].to_i)
  end
end

print reactor.score, "\n"
