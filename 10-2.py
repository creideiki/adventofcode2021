#!/usr/bin/env python

from collections import deque
from math import floor

open_tokens = [ '(', '[', '{', '<' ]
close_tokens = [ ')', ']', '}', '>' ]
match = {
  '(': ')',
  '[': ']',
  '{': '}',
  '<': '>'
}

score_table = {
  ')': 1,
  ']': 2,
  '}': 3,
  '>': 4
}

lines = [line.strip() for line in open('10.input').readlines()]
lines = [list(line) for line in lines]

scores = []

for line in lines:
    stack = deque([])
    corrupted = False

    for token in line:
        if token in open_tokens:
            stack.append(token)
        elif token in close_tokens:
            top = stack[-1]
            if token == match[top]:
                stack.pop()
            else:
                corrupted = True
                break

    if corrupted or len(stack) == 0:
        continue

    stack.reverse()
    completion = [match[token] for token in stack]

    score = 0
    for token in completion:
        score *= 5
        score += score_table[token]
    scores.append(score)

scores.sort()
print(scores[floor(len(scores) / 2)])
