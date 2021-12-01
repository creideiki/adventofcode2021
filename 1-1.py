#!/usr/bin/env python

readings = [int(row) for row in open('1.input').readlines()]

increments = 0
last = readings[0]

for i in range(1, len(readings)):
    if readings[i] > last:
        increments += 1
    last = readings[i]

print(increments)
