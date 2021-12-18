#!/usr/bin/env ruby

class Snailfish
  attr_accessor :pair

  def initialize(pair)
    pair = eval pair if pair.is_a? String
    @pair = pair
  end

  def +(other)
    p = Snailfish.new [@pair, other.pair]
    p.reduce!
    p
  end

  def reduce!
    loop do
      did_explode, new_pair = explode @pair
      @pair = new_pair
      next if did_explode

      did_split, new_pair = split @pair
      @pair = new_pair

      next if did_split

      break
    end
    self
  end

  def increase_rightmost(element, increase)
    return element + increase if element.is_a? Integer

    [element[0], increase_rightmost(element[1], increase)]
  end

  def increase_leftmost(element, increase)
    return element + increase if element.is_a? Integer

    [increase_leftmost(element[0], increase), element[1]]
  end

  def inner_explode(element, level)
    if level == 5 and element.is_a? Array
      [true, 0, element[0], element[1]]
    elsif element.is_a? Integer
      [false, element, nil, nil]
    else
      new_right = element[1]

      did_explode_left, new_left, propagate_left, propagate_right = inner_explode(element[0], level + 1)

      if did_explode_left && propagate_right && propagate_right.positive?
        new_right = increase_leftmost(element[1], propagate_right)
        propagate_right = 0
      end

      did_explode_right = false
      unless did_explode_left
        did_explode_right, new_right, propagate_left, propagate_right = inner_explode(element[1], level + 1)
      end

      if did_explode_right && propagate_left && propagate_left.positive?
        new_left = increase_rightmost(element[0], propagate_left)
        propagate_left = 0
      end

      [
        did_explode_left || did_explode_right,
        [new_left, new_right],
        propagate_left,
        propagate_right
      ]
    end
  end

  def explode(pair)
    did_explode, new_pair, _, _ = inner_explode(pair, 1)
    [did_explode, new_pair]
  end

  def split(element)
    if element.is_a? Integer and element >= 10
      [true, [(element / 2.0).floor, (element / 2.0).ceil]]
    elsif element.is_a? Integer
      [false, element]
    else
      did_split_left, new_left = split element[0]
      did_split_right = false
      new_right = element[1]
      did_split_right, new_right = split element[1] unless did_split_left

      [did_split_left || did_split_right,
       [new_left, new_right]]
    end
  end

  def magnitude(element)
    if element.is_a? Integer
      element
    else
      3 * magnitude(element[0]) + 2 * magnitude(element[1])
    end
  end

  def score
    magnitude @pair
  end

  def to_s
    "<#{self.class}: #{@pair}>"
  end

  def inspect
    to_s
  end
end

input = File.read('18.input').lines.map(&:strip)
additions = input.product(input).reject { |a, b| a == b }

print additions.map { |a, b| (Snailfish.new(a) + Snailfish.new(b)).score }.max, "\n"
