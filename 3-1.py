#!/usr/bin/env python

readings = [r.strip() for r in open('3.input').readlines()]
word_len = len(readings[0])

ones = [0] * word_len
gamma = [0] * word_len
epsilon = [0] * word_len

for bit in range(word_len):
    for reading in readings:
        ones[bit] += int(reading[bit])

    if ones[bit] > len(readings) / 2:
        gamma[bit] = 1
    else:
        epsilon[bit] = 1

power = int(''.join([str(b) for b in gamma]), 2) * \
    int(''.join([str(b) for b in epsilon]), 2)
print(power)
