#!/usr/bin/env ruby

require 'numo/narray'

class Image
  def initialize(enhance, input)
    @mapping = [0] * 512
    enhance.each_index { |i| @mapping[i] = 1 if enhance[i] == '#' }

    @size = input.size
    @image = Numo::UInt8.zeros(@size, @size)
    input.each_index do |row|
      input[row].each_index do |col|
        @image[row, col] = 1 if input[row][col] == '#'
      end
    end

    @background = 0
  end

  def get_pixel(row, col)
    if row.negative? or col.negative? or
       row >= @size or col >= @size
      @background
    else
      @image[row, col]
    end
  end

  def get_grid(row, col)
    num = 0
    [-1, 0, 1].each do |r|
      [-1, 0, 1].each do |c|
        num <<= 1
        num += 1 if get_pixel(row + r, col + c).positive?
      end
    end
    num
  end

  def get_enhanced(row, col)
    @mapping[get_grid(row, col)]
  end

  def enhance!
    new_size = @size + 2
    new_image = Numo::UInt8.zeros(new_size, new_size)
    new_background = @mapping[(@background.to_s * 9).to_i(2)]

    new_size.times do |row|
      new_size.times do |col|
        new_image[row, col] = get_enhanced(row - 1, col - 1)
      end
    end

    @image = new_image
    @size = new_size
    @background = new_background
  end

  def score
    @image.sum
  end

  def to_s
    s = "<#{self.class}:\nSize #{@size}\n"
    @size.times do |row|
      @size.times do |col|
        if @image[row, col].zero?
          s += '.'
        else
          s += '#'
        end
      end
      s += "\n"
    end
    s += '>'
    s
  end
end

input = File.read('20.input').lines.map(&:strip).map { |l| l.split '' }

enh = input.shift

input.shift

img = Image.new(enh, input)

50.times do
  img.enhance!
end

print img.score, "\n"
