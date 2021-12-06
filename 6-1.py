#!/usr/bin/env python

fishes = [int(fish) for fish in open('6.input').readlines()[0].split(",")]

max_days = 80

for day in range(1, max_days + 1):
    next_fishes = []
    for fish in fishes:
        if fish > 0:
            next_fishes.append(fish - 1)
        else:
            next_fishes.append(6)
            next_fishes.append(8)
    fishes = next_fishes

print(len(fishes))
