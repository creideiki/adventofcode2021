#!/usr/bin/env python

import numpy

class Map:
    def __init__(self, input):
        self.size = len(input)
        self.map = numpy.full((self.size, self.size), 0, dtype=numpy.uint)

        for row in range(self.size):
            for col in range(self.size):
                self.map[row, col] = input[row][col]

        self.flashed = numpy.full((self.size, self.size), 0, dtype=numpy.uint)
        self.num_flashes = 0

    def increase(self, row, col):
        if 0 <= row < self.size and \
           0 <= col < self.size:
            self.map[row, col] += 1

    def energize(self):
        for row in range(self.size):
            for col in range(self.size):
                self.increase(row, col)

    def flash(self):
        flashed = False
        for row in range(self.size):
            for col in range(self.size):
                if self.map[row, col] <= 9 or self.flashed[row, col] == 1:
                    continue

                self.num_flashes += 1
                flashed = True
                self.flashed[row, col] = 1
                self.increase(row - 1, col - 1)
                self.increase(row - 1, col)
                self.increase(row - 1, col + 1)
                self.increase(row, col - 1)
                self.increase(row, col + 1)
                self.increase(row + 1, col - 1)
                self.increase(row + 1, col)
                self.increase(row + 1, col + 1)

        return flashed

    def reset(self):
        for row in range(self.size):
            for col in range(self.size):
                if self.flashed[row, col] == 1:
                    self.map[row, col] = 0

        self.flashed.fill(0)

    def step(self):
        self.energize()
        while True:
            if not self.flash():
                break
        self.reset()

    def __str__(self):
        return f"<{self.__class__.__name__}:\nsize: {self.size}\n{self.map}\n>"


input = [list(line.strip()) for line in open('11.input').readlines()]
map = Map(input)

for i in range(100):
    map.step()

print(map.num_flashes)
