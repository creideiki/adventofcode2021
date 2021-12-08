#!/usr/bin/env python

lines = [l.split('|')[1] for l in open('8.input').readlines()]
lines = [l.split() for l in lines]
lines = [item for sublist in lines for item in sublist]

count = 0
for s in lines:
    if len(s) == 2:
        count += 1
    elif len(s) == 4:
        count += 1
    elif len(s) == 3:
        count += 1
    elif len(s) == 7:
        count += 1

print(count)
