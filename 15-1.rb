#!/usr/bin/env ruby

require 'numo/narray'

class Map
  attr_accessor :map
  attr_accessor :size
  attr_accessor :risk

  def initialize(input)
    @size = input.size
    @map = Numo::UInt8.zeros(size, size)
    @risk = Numo::UInt32.zeros(size, size).fill(2**32 - 1)

    input.each_index do |row|
      input[row].each_index do |col|
        @map[row, col] = input[row][col].to_i
      end
    end
  end

  def find_risk
    queue = []
    @size.times do |row|
      @size.times do |col|
        queue.append [row, col]
      end
    end
    @risk[0, 0] = 0

    until queue.empty?
      u = queue.min { |coords| @risk[coords[0], coords[1]] }
      queue.delete u

      neighbours = [
        [u[0] + 1, u[1]],
        [u[0] - 1, u[1]],
        [u[0], u[1] + 1],
        [u[0], u[1] - 1]
      ]
      neighbours.select! do |coords|
        queue.any? coords and
          coords[0] >= 0 and
          coords[0] < @size and
          coords[1] >= 0 and
          coords[1] < @size
      end
      neighbours.each do |v|
        alt = @risk[u[0], u[1]] + @map[v[0], v[1]]
        @risk[v[0], v[1]] = alt if alt < @risk[v[0], v[1]]
      end
    end
    @risk[@size - 1, @size - 1]
  end

  def to_s
    "<#{self.class}:\nsize: #{@size}\n#{@map.inspect}\n>"
  end

  def inspect
    to_s
  end
end

input = File.read('15.input').lines.map(&:strip).map { |l| l.split '' }
map = Map.new(input)
print map.find_risk, "\n"
