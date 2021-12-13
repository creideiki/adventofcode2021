#!/usr/bin/env ruby

require 'numo/narray'

class Map
  attr_accessor :map
  attr_accessor :height
  attr_accessor :width

  def initialize
    @height = 1
    @width = 1
    @map = Numo::UInt8.zeros(@width, @height)
  end

  def expand(x, y)
    expand_height = 0
    if x >= @height
      expand_height = x - @height + 1
    end

    expand_width = 0
    if y >= @width
      expand_width = y - @width + 1
    end

    if expand_width > 0
      @map = @map.append(Numo::UInt8.zeros(expand_width, @height), axis: 0)
    end

    if expand_height > 0
      @map = @map.append(Numo::UInt8.zeros(@width + expand_width, expand_height), axis: 1)
    end

    @height += expand_height
    @width += expand_width
  end

  def [](x, y)
#    expand(x, y)
    @map[y, x]
  end

  def []=(x, y, val)
    expand(x, y)
    @map[y, x] = val
  end

  def fold(axis, coord)
    splits = [coord, coord + 1]
    if axis == :y
      up, *down = @map.split(splits, axis: 0)
      down = down[-1].flipud
      zeros = Numo::UInt8.zeros(up.shape[0] - down.shape[0], @height)
      @map = up + zeros.append(down, axis: 0)
      @width /= 2
    else
      left, *right = @map.split(splits, axis: 1)
      right = right[-1].fliplr
      zeros = Numo::UInt8.zeros(@width, left.shape[1] - right.shape[1])
      @map = left + zeros.append(right, axis: 1)
      @height /= 2
    end
  end

  def count_marks
    count = 0
    @width.times do |y|
      @height.times do |x|
        count += 1 if @map[y, x].positive?
      end
    end
    count
  end

  def to_s
    s = "<#{self.class}:\n"
    s += "Width: #{self.width}\n"
    s += "Height: #{self.height}\n"
    @width.times do |y|
      @height.times do |x|
        s += @map[y, x].zero? ? '.' : '#'
      end
      s += "\n"
    end
    s += '>'
    s
  end

  def inspect
    to_s
  end
end

coord_format = /^(?<x>[[:digit:]]+),(?<y>[[:digit:]]+)$/
fold_format = /^fold along (?<axis>[xy])=(?<coord>[[:digit:]]+)$/

input = File.read('13.input').lines.map(&:strip)

map = Map.new

input.each do |line|
  if (coords = coord_format.match line)
    map[coords['x'].to_i, coords['y'].to_i] = 1
  elsif (fold = fold_format.match line)
    map.fold(fold['axis'].to_sym, fold['coord'].to_i)
  elsif line == ''
  else
    print "Unknown instruction #{line}\n"
  end
end

print map, "\n"
