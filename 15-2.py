#!/usr/bin/env python

import heapq
import numpy

class Map:
    def __init__(self, input):
        tile_size = len(input)
        self.size = tile_size * 5
        self.map = numpy.zeros((self.size, self.size), dtype=numpy.uint)
        self.risk = numpy.empty((self.size, self.size), dtype=numpy.uint)
        self.risk.fill(pow(2, 32) - 1)

        for row in range(len(input)):
            for col in range(len(input)):
                for x in range(5):
                    for y in range(5):
                        r = int(input[row][col]) + x + y
                        if r > 9:
                            r -= 9
                        self.map[row + tile_size * x, col + tile_size * y] = r

    def find_risk(self):
        self.risk[0, 0] = 0

        queue = []
        heapq.heappush(queue, (0, (0, 0)))

        while len(queue) > 0:
            risk, coords = heapq.heappop(queue)
            x, y = coords
            if risk > self.risk[x, y]:
                continue

            ns = [
                [x + 1, y],
                [x - 1, y],
                [x, y + 1],
                [x, y - 1]
            ]

            neighbours = []
            for n in ns:
                if n[0] >= 0 and \
                   n[0] < self.size and \
                   n[1] >= 0 and \
                   n[1] < self.size:
                    neighbours.append((n[0], n[1]))
            for v in neighbours:
                alt = risk + self.map[v[0], v[1]]
                if alt < self.risk[v[0], v[1]]:
                    self.risk[v[0], v[1]] = alt
                    heapq.heappush(queue, (self.risk[v[0], v[1]], (v[0], v[1])))

        return self.risk[self.size - 1, self.size - 1]

    def __str__(self):
        return f"<{self.__class__.__name__}:\Size: {self.size}\n{self.map}\n>"


lines = [list(line.strip()) for line in open('15.input').readlines()]

map = Map(lines)

print(map.find_risk())
