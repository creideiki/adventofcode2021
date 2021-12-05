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
        self.expand(max([x1, x2]), max([y1, y2]))

        if (x2 - x1) == 0:
            dx = 0
        elif (x2 - x1) > 0:
            dx = 1
        elif (x2 - x1) < 0:
            dx = -1

        if (y2 - y1) == 0:
            dy = 0
        elif (y2 - y1) > 0:
            dy = 1
        elif (y2 - y1) < 0:
            dy = -1

        xstart = x1
        ystart = y1

        xl = [x1, x2]
        xl.sort()
        x1, x2 = xl

        yl = [y1, y2]
        yl.sort()
        y1, y2 = yl

        count = max([x2 - x1, y2 - y1])

        for d in range(count + 1):
            self[xstart + dx * d, ystart + dy * d] += 1

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
