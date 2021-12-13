#!/usr/bin/env python

import numpy
import re

class Map:
    def __init__(self):
        self.height = 1
        self.width = 1
        self.map = numpy.zeros((self.width, self.height), dtype=numpy.uint)

    def expand(self, x, y):
        expand_height = 0
        if x >= self.height:
            expand_height = x - self.height + 1

        expand_width = 0
        if y >= self.width:
            expand_width = y - self.width + 1

        if expand_width > 0:
            self.map = numpy.append(self.map, numpy.zeros((expand_width, self.height), dtype=numpy.uint), axis=0)

        if expand_height > 0:
            self.map = numpy.append(self.map, numpy.zeros((self.width + expand_width, expand_height), dtype=numpy.uint), axis=1)

        self.height += expand_height
        self.width += expand_width

    def __getitem__(self, coords):
        x, y = coords
        return self.map[y, x]

    def __setitem__(self, coords, value):
        x, y = coords
        self.expand(x, y)
        self.map[y, x] = value

    def fold(self, axis, coord):
        splits = [coord, coord + 1]
        if axis == 'y':
            up, *down = numpy.split(self.map, splits, axis=0)
            down = numpy.flipud(down[-1])
            zeros = numpy.zeros((up.shape[0] - down.shape[0], self.height), dtype=numpy.uint)
            self.map = up + numpy.append(zeros, down, axis=0)
            self.width //= 2
        else:
            left, *right = numpy.split(self.map, splits, axis=1)
            right = numpy.fliplr(right[-1])
            zeros = numpy.zeros((self.width, left.shape[1] - right.shape[1]), dtype=numpy.uint)
            self.map = left + numpy.append(zeros, right, axis=1)
            self.height //= 2

    def count_marks(self):
        count = 0
        for y in range(self.width):
            for x in range(self.height):
                if self.map[y, x] > 0:
                    count += 1
        return count

    def __str__(self):
        return f"<{self.__class__.__name__}:\nWidth: {self.width}\nHeight: {self.height}\n{self.map}\n>"


lines = [line.strip() for line in open('13.input').readlines()]

coord_format = re.compile("^(?P<x>[0-9]+),(?P<y>[0-9]+)$")
fold_format = re.compile("^fold along (?P<axis>[xy])=(?P<coord>[0-9]+)$")

map = Map()

for line in lines:
    coords = coord_format.match(line)
    fold = fold_format.match(line)

    if coords is not None:
        map[int(coords['x']), int(coords['y'])] = 1
    elif fold is not None:
        map.fold(fold['axis'], int(fold['coord']))
        print(map.count_marks())
        break
    elif line == "":
        pass
    else:
        print(f"Unknown instruction {line}")
