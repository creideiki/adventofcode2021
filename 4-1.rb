#!/usr/bin/env ruby

require 'numo/narray'

class Bingo
  attr_accessor :board
  attr_accessor :marks

  def initialize
    @board = Numo::UInt8.new(5, 5).fill 0
    @marks = Numo::UInt8.new(5, 5).fill 1
  end

  def mark(num)
    0.upto(4) do |row|
      0.upto(4) do |col|
        if @board[row, col] == num
          @marks[row, col] = 0
        end
      end
    end
  end

  def won?
    # Check each row
    0.upto(4) do |row|
      won = true
      0.upto(4) do |col|
        if @marks[row, col] == 1
          won = false
          break
        end
      end
      return true if won
    end

    # Check each column
    0.upto(4) do |col|
      won = true
      0.upto(4) do |row|
        if @marks[row, col] == 1
          won = false
          break
        end
      end
      return true if won
    end

    false
  end

  def score
    (@board * @marks).sum
  end

  def to_s
    s = "<#{self.class}:\n"
    0.upto(4) do |row|
      0.upto(4) do |col|
        s += '*' if @marks[row, col] == 0
        s += @board[row, col].to_s
        s += ' '
      end
      s += "\n"
    end
    s += '>'
    return s
  end
end

input = File.read('4.input').lines.map(&:strip)

draws = input.shift.split(',').map(&:to_i)
boards = []

until input.empty?
  input.shift  # Blank line separator
  board = Bingo.new
  0.upto(4) do |row|
    numbers = input.shift.split.map(&:to_i)
    0.upto(4) do |col|
      board.board[row, col] = numbers[col]
    end
  end
  boards.append board
end

draws.each do |draw|
  boards.each do |board|
    board.mark draw
  end

  winning = boards.index &:won?
  if winning
    print boards[winning].score * draw, "\n"
    exit
  end
end
