#!/usr/bin/env python

import numpy
import re

class Map:
    def __init__(self):
        self.size = 1
        self.map = numpy.zeros((self.size, self.size), dtype=numpy.uint)

    def expand(self, x, y):
        if x >= self.size or y >= self.size:
            expand = max([x - self.size + 1, y - self.size + 1])
            self.map = numpy.append(self.map, numpy.zeros((expand, self.size), dtype=numpy.uint), axis=0)
            self.map = numpy.append(self.map, numpy.zeros((self.size + expand, expand), dtype=numpy.uint), axis=1)
            self.size += expand

    def __getitem__(self, coords):
        x, y = coords
        self.expand(x, y)
        return self.map[x, y]

    def __setitem__(self, coords, value):
        x, y = coords
        self.expand(x, y)
        self.map[x, y] = value

    def mark(self, x1, y1, x2, y2):
        if x1 != x2 and y1 != y2:
            return

        self.expand(max([x1, x2]), max([y1, y2]))

        if x1 == x2:
            l = [y1, y2]
            l.sort()
            y1, y2 = l
            for y in range(y1, y2 + 1):
                self[x1, y] += 1

        if y1 == y2:
            l = [x1, x2]
            l.sort()
            x1, x2 = l
            for x in range(x1, x2 + 1):
                self[x, y1] += 1

    def score(self):
        return len([x for x in self.map.flatten().tolist() if x > 1])

    def __str__(self):
        return f"<{self.__class__.__name__}:\nsize: {self.size}\n{self.map.transpose()}\nscore: {self.score()}>"


lines = [line.strip() for line in open('5.input').readlines()]

line_format = re.compile("(?P<x1>[0-9]+),(?P<y1>[0-9]+) -> (?P<x2>[0-9]+),(?P<y2>[0-9]+)")

map = Map()

for line in lines:
    l = line_format.match(line)
    map.mark(int(l['x1']),
             int(l['y1']),
             int(l['x2']),
             int(l['y2']))

print(map.score())
