#!/usr/bin/env python

days = [int(fish) for fish in open('6.input').readlines()[0].split(",")]

max_days = 256

fishes = [0] * 9

for day in days:
    fishes[day] += 1

for day in range(1, max_days + 1):
    next_fishes = [0] * 9
    next_fishes[8] = fishes[0]
    next_fishes[7] = fishes[8]
    next_fishes[6] = fishes[7] + fishes[0]
    next_fishes[5] = fishes[6]
    next_fishes[4] = fishes[5]
    next_fishes[3] = fishes[4]
    next_fishes[2] = fishes[3]
    next_fishes[1] = fishes[2]
    next_fishes[0] = fishes[1]
    fishes = next_fishes

print(sum(fishes))
