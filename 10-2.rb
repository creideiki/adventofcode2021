#!/usr/bin/env ruby

open = [ '(', '[', '{', '<' ]
close = [ ')', ']', '}', '>' ]
match = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

score_table = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

lines = File.read('10.input').lines.map(&:strip).map { |l| l.split '' }

scores = []

lines.each do |line|
  stack = []
  corrupted = false

  line.each do |token|
    if open.any? token
      stack.push token
    elsif close.any? token
      top = stack[-1]
      if token == match[top]
        stack.pop
      else
        corrupted = true
        break
      end
    end
  end

  next if corrupted or stack.empty?

  completion = stack.reverse.map { |token| match[token] }

  score = 0
  completion.each do |token|
    score *= 5
    score += score_table[token]
  end
  scores.append score
end

scores.sort!
print scores[scores.size / 2], "\n"
