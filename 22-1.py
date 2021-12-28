#!/usr/bin/env python

import numpy
import re

class Reactor:
    def __init__(self):
        self.map = numpy.zeros((101, 101, 101), dtype=numpy.uint)

    def outside(self, c1, c2):
        return (c1 < -50 and c2 < -50) or \
            (c1 > 50 and c2 > 50)

    def mark(self, on, x1, x2, y1, y2, z1, z2):
        xmin = min([x1, x2])
        xmax = max([x1, x2])
        ymin = min([y1, y2])
        ymax = max([y1, y2])
        zmin = min([z1, z2])
        zmax = max([z1, z2])
        if self.outside(xmin, xmax) or \
           self.outside(ymin, ymax) or \
           self.outside(zmin, zmax):
            return

        for x in range(xmin, xmax + 1):
            for y in range(ymin, ymax + 1):
                for z in range(zmin, zmax + 1):
                    self.map[x + 50, y + 50, z + 50] = 1 if on else 0

    def score(self):
        return numpy.sum(self.map)


lines = [line.strip() for line in open('22.input').readlines()]
line_format = re.compile("^(?P<set>on|off) x=(?P<x1>[0-9\-]+)..(?P<x2>[0-9\-]+),y=(?P<y1>[0-9\-]+)..(?P<y2>[0-9\-]+),z=(?P<z1>[0-9\-]+)..(?P<z2>[0-9\-]+)$")

reactor = Reactor()

for line in lines:
    l = line_format.match(line)
    mark = True if l["set"] == "on" else False
    reactor.mark(mark,
                 int(l["x1"]),
                 int(l["x2"]),
                 int(l["y1"]),
                 int(l["y2"]),
                 int(l["z1"]),
                 int(l["z2"]))

print(reactor.score())
