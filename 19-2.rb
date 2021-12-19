#!/usr/bin/env ruby

require 'matrix'

class Scanner
  attr_accessor :beacons
  attr_accessor :distances
  attr_accessor :id

  def initialize(id)
    @id = id
    @beacons = []
    @distances = []
  end

  def add_beacon(x, y, z)
    @beacons.append Matrix[[x], [y], [z]]
  end

  def calculate_distances!
    @beacons.permutation(2) do |b1, b2|
      @distances.append (b1[0, 0] - b2[0, 0]).abs**2 +
                        (b1[1, 0] - b2[1, 0]).abs**2 +
                        (b1[2, 0] - b2[2, 0]).abs**2
    end
    @distances.sort!
  end

  def match_distances(other)
    matching = 0
    @distances.each { |d| matching += 1 if other.distances.bsearch { |e| d <=> e } }
    matching
  end

  def match_distances?(other)
    match_distances(other) >= 66  # 66 == 12 choose 2
  end

  def all_rotations
    # https://stackoverflow.com/a/51836928
    as = [[[1, 0, 0],
           [0, 1, 0],
           [0, 0, 1]],

          [[0, 1, 0],
           [0, 0, 1],
           [1, 0, 0]],

          [[0, 0, 1],
           [1, 0, 0],
           [0, 1, 0]]].map { |m| Matrix[*m] }

    bs = [[[1, 0, 0],
           [0, 1, 0],
           [0, 0, 1]],

          [[-1, 0, 0],
           [ 0,-1, 0],
           [ 0, 0, 1]],

          [[-1, 0, 0],
           [ 0, 1, 0],
           [ 0, 0,-1]],

          [[ 1, 0, 0],
           [ 0,-1, 0],
           [ 0, 0,-1]]].map { |m| Matrix[*m] }

    cs = [[[1, 0, 0],
           [0, 1, 0],
           [0, 0, 1]],

          [[ 0, 0,-1],
           [ 0,-1, 0],
           [-1, 0, 0]]].map { |m| Matrix[*m] }

    rotations = []
    as.each do |a|
      bs.each do |b|
        cs.each do |c|
          rotations.append a * b * c
        end
      end
    end
    rotations
  end

  def match_coords(other)
    all_rotations.each do |rotation|
      rotated = other.beacons.map { |coords| rotation * coords }

      rotated.each do |r|
        @beacons.each do |b|
          translation = r - b
          translated = 0
          to_translate = @beacons.dup
          until to_translate.empty?
            coords = to_translate.shift
            if rotated.any? (coords + translation)
              translated += 1
            end
          end
          return [true, rotation, translation] if translated >= 12
        end
      end
    end
    [false, nil, nil]
  end

  def transform!(rotation, translation)
    @beacons = transformed_coords(rotation, translation)
  end

  def transformed_coords(rotation, translation)
    @beacons.map do |b|
      rotation * b - translation
    end
  end

  def to_s
    s = "<#{self.class}: #{@id}\n"
    @beacons.each do |b|
      s += "(#{b[0, 0]}, #{b[1, 0]}, #{b[2, 0]})\n"
    end
    s += "\n#{@distances}\n>"
    s
  end

  def inspect
    to_s
  end
end

class Map
  attr_accessor :map

  def initialize
    @map = {}
  end

  def mark(beacon)
    self[beacon[0, 0],
         beacon[1, 0],
         beacon[2, 0]] = 1
  end

  def [](x, y, z)
    @map[[x, y, z]]
  end

  def []=(x, y, z, val)
    @map[[x, y, z]] = val
  end

  def score
    @map.values.size
  end

  def to_s
    s = "<#{self.class}:\n"
    @map.each_key do |m|
      s += "(#{m[0]}, #{m[1]}, #{m[2]})\n"
    end
    s += "\nScore: #{score}\n>"
    s
  end

  def inspect
    to_s
  end
end

header_format = /^--- scanner (?<id>[[:digit:]]+) ---$/
beacon_format = /^(?<x>[[:digit:]\-]+),(?<y>[[:digit:]\-]+),(?<z>[[:digit:]\-]+)$/

input = File.read('19.input').lines.map(&:strip)

scanners = []

until input.empty?
  h = header_format.match input.shift
  id = h['id'].to_i
  s = Scanner.new(id)

  loop do
    l = input.shift
    break if not l or l.empty?

    b = beacon_format.match l
    s.add_beacon(b['x'].to_i, b['y'].to_i, b['z'].to_i)
  end
  s.calculate_distances!
  scanners.append s
end

map = Map.new
scanners[0].beacons.each { |b| map.mark b }

checked = []
locked = [scanners[0]]
to_check = scanners[1..]
translations = []

until to_check.empty?
  found = []
  locked.each do |l|
    to_check.each do |t|
      next if l.id == t.id
      next if checked.any? [l.id, t.id] or checked.any? [t.id, l.id]

      checked.append [l.id, t.id]
      if l.match_distances? t
        res, rotation, translation = l.match_coords t
        if res
          found.append t
          t.transform!(rotation, translation)
          t.beacons.each { |c| map.mark c }
          translations.append translation
        end
      end
    end
  end
  locked += found
  to_check -= found
end

max_dist = 0
translations.product(translations) do |s1, s2|
  dist = (s1[0, 0] - s2[0, 0]).abs +
         (s1[1, 0] - s2[1, 0]).abs +
         (s1[2, 0] - s2[2, 0]).abs
  if dist > max_dist
    max_dist = dist
  end
end

print max_dist, "\n"
