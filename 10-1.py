#!/usr/bin/env python

from collections import deque

open_tokens = [ '(', '[', '{', '<' ]
close_tokens = [ ')', ']', '}', '>' ]
match = {
  '(': ')',
  '[': ']',
  '{': '}',
  '<': '>'
}

score = {
  ')': 3,
  ']': 57,
  '}': 1197,
  '>': 25137
}

lines = [line.strip() for line in open('10.input').readlines()]
lines = [list(line) for line in lines]

errors = []

for line in lines:
    stack = deque([])
    for token in line:
        if token in open_tokens:
            stack.append(token)
        elif token in close_tokens:
            top = stack[-1]
            if token == match[top]:
                stack.pop()
            else:
                errors.append(token)
                break

print(sum([score[token] for token in errors]))
