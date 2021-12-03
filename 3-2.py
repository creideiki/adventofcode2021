#!/usr/bin/env python

import math

readings = [r.strip() for r in open('3.input').readlines()]
word_len = len(readings[0])

oxygen = readings.copy()
co2 = readings.copy()

for bit in range(word_len):
    if len(oxygen) > 1:
        ones = 0
        most_common = 0
        for o in oxygen:
            ones += int(o[bit])
        if ones >= math.ceil(len(oxygen) / 2):
            most_common = 1
        oxygen = [o for o in oxygen if int(o[bit]) != most_common]

    if len(co2) > 1:
        ones = 0
        most_common = 0
        for c in co2:
            ones += int(c[bit])
        if ones >= math.ceil(len(co2) / 2):
            most_common = 1
        co2 = [c for c in co2 if int(c[bit]) == most_common]

life_support = int(oxygen[0], 2) * int(co2[0], 2)

print(life_support)
