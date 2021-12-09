#!/usr/bin/env ruby

require 'numo/narray'

class Map
  attr_accessor :map
  attr_accessor :height
  attr_accessor :width

  def initialize(input)
    @height = input.size
    @width = input[0].size
    @map = Numo::UInt8.new(height + 2, width + 2)
    @map.fill(10)

    input.each_index do |row|
      input[row].each_index do |col|
        @map[row + 1, col + 1] = input[row][col].to_i
      end
    end
  end

  def [](row, col)
    @map[row + 1, col + 1]
  end

  def []=(row, col, val)
    @map[row + 1, col + 1] = val
  end

  def local_minima()
    minima = []
    1.upto(@height) do |row|
      1.upto(@width) do |col|
        if @map[row, col] < @map[row - 1, col] and
           @map[row, col] < @map[row + 1, col] and
           @map[row, col] < @map[row, col - 1] and
           @map[row, col] < @map[row, col + 1]
          minima.append [row, col]
        end
      end
    end
    minima
  end

  def boundary?(row, col)
    return true if @map[row, col] >= 9

    false
  end

  def flood_fill(row, col)
    basin = []
    queue = [[row, col]]
    visited = []
    until queue.empty?
      row, col = queue.shift
      next if visited.any? [row, col]

      visited.append [row, col]
      next if boundary?(row, col)

      basin.append [row, col] unless basin.any? [row, col]
      queue.append [row - 1, col] unless queue.any? [row - 1, col]
      queue.append [row + 1, col] unless queue.any? [row + 1, col]
      queue.append [row, col - 1] unless queue.any? [row, col - 1]
      queue.append [row, col + 1] unless queue.any? [row, col + 1]
    end
    basin
  end

  def score
    local_minima.map { |x| x + 1 }.sum
  end

  def to_s
    "<#{self.class}:\nsize: #{@size}\n#{@map.inspect}\n>"
  end

  def inspect
    "<#{self.class}:\nsize: #{@size}\n#{@map.inspect}\n>"
  end
end

input = File.read('9.input').lines.map(&:strip).map { |l| l.split '' }
map = Map.new(input)
min = map.local_minima
print min.map { |c| map.flood_fill(c[0], c[1]) }.map(&:size).sort { |a, b| b <=> a }.take(3).reduce(1) { |m, e| m * e }
print "\n"
