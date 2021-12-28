#!/usr/bin/env python

import numpy

class Map:
    def __init__(self, lines):
        self.height = len(lines)
        self.width = len(lines[0])
        self.map = numpy.zeros((self.height, self.width), dtype=numpy.uint)

        for row in range(self.height):
            for col in range(self.width):
                self.map[row, col] = self.decode(lines[row][col])

    def decode(self, symbol):
        if symbol == ".":
            return 0
        elif symbol == '>':
            return 1
        elif symbol == 'v':
            return 2

    def encode(self, number):
        if number == 0:
            return "."
        elif number == 1:
            return ">"
        elif number == 2:
            return "v"

    def step(self):
        changed = False

        new_map = numpy.zeros((self.height, self.width), dtype=numpy.uint)

        for y in range(self.height):
            for x in range(self.width):
                if self.map[y, x] == 2:
                    new_map[y, x] = 2

                if self.map[y, x] != 1:
                    continue

                if self.map[y, (x + 1) % self.width] != 0:
                    new_map[y, x] = 1
                else:
                    new_map[y, x] = 0
                    new_map[y, (x + 1) % self.width] = 1
                    changed = True

        self.map = new_map

        new_map = numpy.zeros((self.height, self.width), dtype=numpy.uint)

        for x in range(self.width):
            for y in range(self.height):
                if self.map[y, x] == 1:
                    new_map[y, x] = 1

                if self.map[y, x] != 2:
                    continue

                if self.map[(y + 1) % self.height, x] != 0:
                    new_map[y, x] = 2
                else:
                    new_map[y, x] = 0
                    new_map[(y + 1) % self.height, x] = 2
                    changed = True

        self.map = new_map
        return changed


    def __str__(self):
        s = f"<{self.__class__.__name__}: (height: {self.height}, width: {self.width})\n"
        for y in range(self.height):
            for x in range(self.width):
                s += self.encode(self.map[y, x])
            s += "\n"
        s += '>'
        return s


lines = [list(line.strip()) for line in open('25.input').readlines()]

map = Map(lines)

steps = 0

while True:
    steps += 1
    if not map.step():
        break

print(steps)
