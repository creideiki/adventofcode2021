#!/usr/bin/env ruby

class Cuboid
  attr_accessor :xmin, :xmax, :ymin, :ymax, :zmin, :zmax

  def initialize(xmin, xmax, ymin, ymax, zmin, zmax)
    @xmin = xmin
    @xmax = xmax
    @ymin = ymin
    @ymax = ymax
    @zmin = zmin
    @zmax = zmax
  end

  def intersects?(other)
    other.xmin <= @xmax and other.xmax >= @xmin and
      other.ymin <= @ymax and other.ymax >= @ymin and
      other.zmin <= @zmax and other.zmax >= @zmin
  end

  def volume
    (@xmax - @xmin + 1) *
      (@ymax - @ymin + 1) *
      (@zmax - @zmin + 1)
  end

  def union(other)
    return [self, other] unless intersects? other

    new_parts = [self]
    work = other.dup

    if work.xmin < @xmin
      new_parts.append Cuboid.new(work.xmin, @xmin - 1, work.ymin, work.ymax, work.zmin, work.zmax)
      work.xmin = xmin
    end

    if work.xmax > @xmax
      new_parts.append Cuboid.new(@xmax + 1, work.xmax, work.ymin, work.ymax, work.zmin, work.zmax)
      work.xmax = xmax
    end

    if work.ymin < @ymin
      new_parts.append Cuboid.new(work.xmin, work.xmax, work.ymin, @ymin - 1, work.zmin, work.zmax)
      work.ymin = ymin
    end

    if work.ymax > @ymax
      new_parts.append Cuboid.new(work.xmin, work.xmax, @ymax + 1, work.ymax, work.zmin, work.zmax)
      work.ymax = ymax
    end

    if work.zmin < @zmin
      new_parts.append Cuboid.new(work.xmin, work.xmax, work.ymin, work.ymax, work.zmin, @zmin - 1)
      work.zmin = zmin
    end

    if work.zmax > @zmax
      new_parts.append Cuboid.new(work.xmin, work.xmax, work.ymin, work.ymax, @zmax + 1, work.zmax)
      work.zmax = @zmax
    end

    new_parts
  end

  def subtract(other)
    return [self] unless intersects? other

    new_parts = []
    work = self.dup

    if other.xmin <= work.xmax and other.xmin > work.xmin
      new_parts.append Cuboid.new(work.xmin, other.xmin - 1, work.ymin, work.ymax, work.zmin, work.zmax)
      work.xmin = other.xmin
    end

    if other.xmax >= work.xmin and other.xmax < work.xmax
      new_parts.append Cuboid.new(other.xmax + 1, work.xmax, work.ymin, work.ymax, work.zmin, work.zmax)
      work.xmax = other.xmax
    end

    if other.ymin <= work.ymax and other.ymin > work.ymin
      new_parts.append Cuboid.new(work.xmin, work.xmax, work.ymin, other.ymin - 1, work.zmin, work.zmax)
      work.ymin = other.ymin
    end

    if other.ymax >= work.ymin and other.ymax < work.ymax
      new_parts.append Cuboid.new(work.xmin, work.xmax, other.ymax + 1, work.ymax, work.zmin, work.zmax)
      work.ymax = other.ymax
    end

    if other.zmin <= work.zmax and other.zmin > work.zmin
      new_parts.append Cuboid.new(work.xmin, work.xmax, work.ymin, work.ymax, work.zmin, other.zmin - 1)
      work.zmin = other.zmin
    end

    if other.zmax >= work.zmin and other.zmax < work.zmax
      new_parts.append Cuboid.new(work.xmin, work.xmax, work.ymin, work.ymax, other.zmax + 1, work.zmax)
      work.zmax = other.zmax
    end

    new_parts
  end

  def to_s
    "<#{self.class}: X: #{@xmin}..#{@xmax}, Y: #{@ymin}..#{@ymax}, Z: #{@zmin}..#{@zmax}>"
  end

  def inspect
    to_s
  end
end

class Reactor
  attr_accessor :cuboids

  def initialize
    @cuboids = []
  end

  def mark(set, x1, x2, y1, y2, z1, z2)
    new = Cuboid.new(x1, x2, y1, y2, z1, z2)
    new_cuboids = @cuboids.map { |c| c.subtract new }.flatten
    new_cuboids.append new if set
    @cuboids = new_cuboids
  end

  def score
    @cuboids.map(&:volume).sum
  end

  def to_s
    s = "<#{self.class}:\n"
    @cuboids.each { |c| s += c.to_s + "\n" }
    s += ">"
    s
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
