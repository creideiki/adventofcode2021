#!/usr/bin/env python

import numpy

class Map:
    def __init__(self, input):
        self.height = len(input)
        self.width = len(input[0])
        self.map = numpy.full((self.height + 2, self.width + 2), 10, dtype=numpy.uint)

        for row in range(len(input)):
            for col in range(len(input[row])):
                self.map[row + 1, col + 1] = int(input[row][col])

    def local_minima(self):
        minima = []
        for row in range(1, self.height + 1):
            for col in range(1, self.width + 1):
                if self.map[row, col] < self.map[row - 1, col] and \
                   self.map[row, col] < self.map[row + 1, col] and \
                   self.map[row, col] < self.map[row, col - 1] and \
                   self.map[row, col] < self.map[row, col + 1]:
                    minima.append(self.map[row, col])
        return minima

    def score(self):
        return int(sum([x + 1 for x in self.local_minima()]))

    def __str__(self):
        return f"<{self.__class__.__name__}:\nsize: {self.size}\n{self.map}\nscore: {self.score()}>"


lines = [line.strip() for line in open('9.input').readlines()]
input = [list(line) for line in lines]
map = Map(input)
print(map.score())
