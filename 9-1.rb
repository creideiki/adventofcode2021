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
          minima.append @map[row, col]
        end
      end
    end
    minima
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
print map.score, "\n"
