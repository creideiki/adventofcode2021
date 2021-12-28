#!/usr/bin/env ruby

require 'numo/narray'

class Map
  def initialize(input)
    @height = input.size
    @width = input[0].size
    @map = Numo::UInt8.zeros(@height, @width)

    input.each_index do |row|
      input[row].each_index do |col|
        @map[row, col] = decode(input[row][col])
      end
    end
  end

  def decode(symbol)
    case symbol
    when '.'
      0
    when '>'
      1
    when 'v'
      2
    end
  end

  def encode(number)
    case number
    when 0
      '.'
    when 1
      '>'
    when 2
      'v'
    end
  end

  def step!
    changed = false

    new_map = Numo::UInt8.zeros(@height, @width)

    @height.times do |y|
      @width.times do |x|
        new_map[y, x] = 2 if @map[y, x] == 2

        next if @map[y, x] != 1

        if @map[y, (x + 1) % @width] != 0
          new_map[y, x] = 1
        else
          new_map[y, x] = 0
          new_map[y, (x + 1) % @width] = 1
          changed = true
        end
      end
    end

    @map = new_map
    new_map = Numo::UInt8.zeros(@height, @width)

    @width.times do |x|
      @height.times do |y|
        new_map[y, x] = 1 if @map[y, x] == 1

        next if @map[y, x] != 2

        if @map[(y + 1) % @height, x] != 0
          new_map[y, x] = 2
        else
          new_map[y, x] = 0
          new_map[(y + 1) % @height, x] = 2
          changed = true
        end
      end
    end

    @map = new_map
    changed
  end

  def to_s
    s = "<#{self.class}: (height: #{@height}, width: #{@width})\n"
    @height.times do |y|
      @width.times do |x|
        s += encode(@map[y, x])
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

input = File.read('25.input').lines.map(&:strip).map { |l| l.split '' }

map = Map.new input

steps = 0
loop do
  steps += 1
  break unless map.step!
end

print steps, "\n"
