#!/usr/bin/env python

from copy import deepcopy
from itertools import chain
import re

class Cuboid:
    def __init__(self, xmin, xmax, ymin, ymax, zmin, zmax):
        self.xmin = xmin
        self.xmax = xmax
        self.ymin = ymin
        self.ymax = ymax
        self.zmin = zmin
        self.zmax = zmax

    def intersects(self, other):
        return \
            other.xmin <= self.xmax and other.xmax >= self.xmin and \
            other.ymin <= self.ymax and other.ymax >= self.ymin and \
            other.zmin <= self.zmax and other.zmax >= self.zmin

    def volume(self):
        return \
            (self.xmax - self.xmin + 1) * \
            (self.ymax - self.ymin + 1) * \
            (self.zmax - self.zmin + 1)

    def union(self, other):
        if not self.intersects(other):
            return [self, other]

        new_parts = [self]
        work = deepcopy(other)

        if work.xmin < self.xmin:
            new_parts.append(Cuboid(work.xmin, self.xmin - 1, work.ymin, work.ymax, work.zmin, work.zmax))
            work.xmin = xmin

        if work.xmax > self.xmax:
            new_parts.append(Cuboid(self.xmax + 1, work.xmax, work.ymin, work.ymax, work.zmin, work.zmax))
            work.xmax = xmax

        if work.ymin < self.ymin:
            new_parts.append(Cuboid(work.xmin, work.xmax, work.ymin, self.ymin - 1, work.zmin, work.zmax))
            work.ymin = ymin

        if work.ymax > self.ymax:
            new_parts.append(Cuboid(work.xmin, work.xmax, self.ymax + 1, work.ymax, work.zmin, work.zmax))
            work.ymax = ymax

        if work.zmin < self.zmin:
            new_parts.append(Cuboid(work.xmin, work.xmax, work.ymin, work.ymax, work.zmin, self.zmin - 1))
            work.zmin = zmin

        if work.zmax > self.zmax:
            new_parts.append(Cuboid(work.xmin, work.xmax, work.ymin, work.ymax, self.zmax + 1, work.zmax))
            work.zmax = self.zmax

        return new_parts

    def subtract(self, other):
        if not self.intersects(other):
            return [self]

        new_parts = []
        work = deepcopy(self)

        if other.xmin <= work.xmax and other.xmin > work.xmin:
            new_parts.append(Cuboid(work.xmin, other.xmin - 1, work.ymin, work.ymax, work.zmin, work.zmax))
            work.xmin = other.xmin

        if other.xmax >= work.xmin and other.xmax < work.xmax:
            new_parts.append(Cuboid(other.xmax + 1, work.xmax, work.ymin, work.ymax, work.zmin, work.zmax))
            work.xmax = other.xmax

        if other.ymin <= work.ymax and other.ymin > work.ymin:
            new_parts.append(Cuboid(work.xmin, work.xmax, work.ymin, other.ymin - 1, work.zmin, work.zmax))
            work.ymin = other.ymin

        if other.ymax >= work.ymin and other.ymax < work.ymax:
            new_parts.append(Cuboid(work.xmin, work.xmax, other.ymax + 1, work.ymax, work.zmin, work.zmax))
            work.ymax = other.ymax

        if other.zmin <= work.zmax and other.zmin > work.zmin:
            new_parts.append(Cuboid(work.xmin, work.xmax, work.ymin, work.ymax, work.zmin, other.zmin - 1))
            work.zmin = other.zmin

        if other.zmax >= work.zmin and other.zmax < work.zmax:
            new_parts.append(Cuboid(work.xmin, work.xmax, work.ymin, work.ymax, other.zmax + 1, work.zmax))
            work.zmax = other.zmax

        return new_parts


class Reactor:
    def __init__(self):
        self.cuboids = []

    def mark(self, on, x1, x2, y1, y2, z1, z2):
        new = Cuboid(x1, x2, y1, y2, z1, z2)
        new_cuboids = list(chain.from_iterable([c.subtract(new) for c in self.cuboids]))
        if on:
            new_cuboids.append(new)
        self.cuboids = new_cuboids

    def score(self):
        return sum([c.volume() for c in self.cuboids])


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
