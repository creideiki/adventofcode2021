#!/usr/bin/env python

import numpy

class Map:
    def __init__(self, input):
        self.size = len(input)
        self.map = numpy.zeros((self.size, self.size), dtype=numpy.uint)
        self.risk = numpy.empty((self.size, self.size), dtype=numpy.uint)
        self.risk.fill(pow(2, 32) - 1)

        for row in range(len(input)):
            for col in range(len(input)):
                self.map[row, col] = int(input[row][col])

    def find_risk(self):
        queue = []
        for row in range(self.size):
            for col in range(self.size):
                queue.append((row, col))
        self.risk[0, 0] = 0

        while len(queue) > 0:
            min_risk = pow(2, 32)
            min_coords = (0, 0)
            min_index = 0
            for index in range(len(queue)):
                risk = self.risk[queue[index][0], queue[index][1]]
                if risk < min_risk:
                    min_risk = risk
                    min_coords = (queue[index][0], queue[index][1])
                    min_index = index
            del queue[min_index]
            u = min_coords

            ns = [
                [u[0] + 1, u[1]],
                [u[0] - 1, u[1]],
                [u[0], u[1] + 1],
                [u[0], u[1] - 1]
            ]

            neighbours = []
            for n in ns:
                if n[0] >= 0 and \
                   n[0] < self.size and \
                   n[1] >= 0 and \
                   n[1] < self.size and \
                   (n[0], n[1]) in queue:
                    neighbours.append((n[0], n[1]))
            for v in neighbours:
                alt = self.risk[u[0], u[1]] + self.map[v[0], v[1]]
                if alt < self.risk[v[0], v[1]]:
                    self.risk[v[0], v[1]] = alt

        return self.risk[self.size - 1, self.size - 1]

    def __str__(self):
        return f"<{self.__class__.__name__}:\Size: {self.size}\n{self.map}\n>"


lines = [list(line.strip()) for line in open('15.input').readlines()]

map = Map(lines)

print(map.find_risk())
