#!/usr/bin/env ruby

require 'numo/narray'
require 'algorithms'

class Map
  attr_accessor :map
  attr_accessor :size
  attr_accessor :risk

  def initialize(input)
    tile_size = input.size
    @size = tile_size * 5
    @map = Numo::UInt8.zeros(size, size)
    @risk = Numo::UInt32.zeros(size, size).fill(2**32 - 1)

    input.each_index do |row|
      input[row].each_index do |col|
        5.times do |x|
          5.times do |y|
            r = input[row][col].to_i + x + y
            r -= 9 if r > 9
            @map[row + tile_size * x, col + tile_size * y] = r
          end
        end
      end
    end
  end

  def find_risk
    @risk[0, 0] = 0

    queue = Containers::MinHeap.new
    queue.push(0, [0, 0])

    until queue.empty?
      risk = queue.next_key
      x, y = queue.pop
      next if risk > @risk[x, y]

      neighbours = [
        [x + 1, y],
        [x - 1, y],
        [x, y + 1],
        [x, y - 1]
      ]
      neighbours.select! do |coords|
        coords[0] >= 0 and
          coords[0] < @size and
          coords[1] >= 0 and
          coords[1] < @size
      end
      neighbours.each do |v|
        alt = risk + @map[v[0], v[1]]
        if alt < @risk[v[0], v[1]]
          @risk[v[0], v[1]] = alt
          queue.push(@risk[v[0], v[1]], [v[0], v[1]])
        end
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
