#!/usr/bin/env ruby

class Map
  attr_accessor :neighbours
  attr_accessor :paths

  def initialize
    @neighbours = Hash.new { Array.new }
    @paths = -1
  end

  def connect(cave1, cave2)
    n1 = @neighbours[cave1]
    n2 = @neighbours[cave2]

    n1.append cave2 unless n1.any? cave2
    n2.append cave1 unless n2.any? cave1

    @neighbours[cave1] = n1
    @neighbours[cave2] = n2
  end

  def visit(cave, path)
    if cave == 'end'
      @paths += 1
    else
      path += [cave]
      @neighbours[cave].each do |n|
        if n == 'start'
          # Returned to start
          next
        elsif n == n.downcase and
             path.count(n) >= 1 and
             path.detect { |c| c == c.downcase and path.count(c) > 1 }
          next
        else
          visit(n, path)
        end
      end
    end
  end

  def count_paths
    return @paths unless @paths.negative?

    @paths = 0
    visit('start', [])
    @paths
  end

  def to_s
    s = "<#{self.class} (#{@paths}):\n"
    @neighbours.each do |cave, neighbours|
      s += "#{cave} -> #{neighbours}\n"
    end
    s += '>'
    s
  end

  def inspect
    to_s
  end
end

map = Map.new

input = File.read('12.input').lines.map(&:strip).map { |row| (row.split '-') }

input.each do |conn|
  map.connect conn[0], conn[1]
end

print map.count_paths, "\n"
