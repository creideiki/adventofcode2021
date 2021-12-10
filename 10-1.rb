#!/usr/bin/env ruby

open = [ '(', '[', '{', '<' ]
close = [ ')', ']', '}', '>' ]
match = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

score = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

lines = File.read('10.input').lines.map(&:strip).map { |l| l.split '' }

errors = []

lines.each do |line|
  stack = []
  line.each do |token|
    if open.any? token
      stack.push token
    elsif close.any? token
      top = stack[-1]
      if token == match[top]
        stack.pop
      else
        errors.push token
        break
      end
    end
  end
end

print errors.map { |token| score[token] }.sum
print "\n"
