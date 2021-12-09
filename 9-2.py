#!/usr/bin/env python

from collections import deque
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
                    minima.append([row, col])
        return minima

    def boundary(self, row, col):
        if self.map[row, col] >= 9:
            return True
        else:
            return False

    def flood_fill(self, row, col):
        basin = []
        queue = deque([[row, col]])
        visited = []
        while len(queue) > 0:
            row, col = queue.popleft()
            if [row, col] in visited:
                continue

            visited.append([row, col])
            if self.boundary(row, col):
                continue

            if [row, col] not in basin:
                basin.append([row, col])
            if [row - 1, col] not in queue:
                queue.append([row - 1, col])
            if [row + 1, col] not in queue:
                queue.append([row + 1, col])
            if [row, col - 1] not in queue:
                queue.append([row, col - 1])
            if [row, col + 1] not in queue:
                queue.append([row, col + 1])

        return basin

    def __str__(self):
        return f"<{self.__class__.__name__}:\nsize: {self.size}\n{self.map}\nscore: {self.score()}>"


lines = [line.strip() for line in open('9.input').readlines()]
input = [list(line) for line in lines]
map = Map(input)
min = map.local_minima()
basins = [map.flood_fill(c[0], c[1]) for c in min]
sizes = [len(b) for b in basins]
sizes.sort(reverse=True)
print(sizes[0] * sizes[1] * sizes[2])
