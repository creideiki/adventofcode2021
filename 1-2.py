#!/usr/bin/env python

readings = [int(row) for row in open('1.input').readlines()]

increments = 0
win_size = 3
last = sum(readings[0:win_size])

for i in range(1, len(readings)):
    win_sum = sum(readings[i:i + win_size])
    if win_sum > last:
        increments += 1
    last = win_sum

print(increments)
