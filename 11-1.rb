#!/usr/bin/env ruby

require 'numo/narray'

class Map
  attr_accessor :num_flashes

  def initialize(input)
    @size = 10
    @map = Numo::UInt8.zeros(@size, @size)
    input.each_index do |row|
      input[row].each_index do |col|
        @map[row, col] = input[row][col]
      end
    end
    @flashed = Numo::UInt8.zeros(@size, @size)
    @num_flashes = 0
  end

  def increase(row, col)
    return unless row.between?(0, @size - 1)
    return unless col.between?(0, @size - 1)

    @map[row, col] += 1
  end

  def energize
    @size.times do |row|
      @size.times do |col|
        increase(row, col)
      end
    end
  end

  def flash
    flashed = false
    @size.times do |row|
      @size.times do |col|
        next unless @map[row, col] > 9 and
          @flashed[row, col].zero?

        @num_flashes += 1
        flashed = true
        @flashed[row, col] = 1
        increase(row - 1, col - 1)
        increase(row - 1, col)
        increase(row - 1, col + 1)
        increase(row, col - 1)
        increase(row, col + 1)
        increase(row + 1, col - 1)
        increase(row + 1, col)
        increase(row + 1, col + 1)
      end
    end
    flashed
  end

  def reset
    @size.times do |row|
      @size.times do |col|
        @map[row, col] = 0 if @flashed[row, col] == 1
      end
    end
    @flashed.fill 0
  end

  def step
    energize
    loop do
      break unless flash
    end
    reset
  end

  def to_s
    s = "<#{self.class}:\n"
    @size.times do |row|
      @size.times do |col|
        s += "#{@map[row, col]} "
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

input = File.read('11.input').lines.map(&:strip).map { |row| (row.split '').map &:to_i }

map = Map.new(input)

100.times { |_| map.step }

print map.num_flashes, "\n"
