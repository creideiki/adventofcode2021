#!/usr/bin/env python

crabs = [int(crab) for crab in open('7.input').readlines()[0].split(",")]

leftmost = min(crabs)
rightmost = max(crabs)

cost = [0] * (rightmost + 1)

for gather in range(leftmost, rightmost + 1):
    cost[gather] = sum([abs(gather - crab) for crab in crabs])

print(min(cost))
