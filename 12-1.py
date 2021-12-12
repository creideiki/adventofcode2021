#!/usr/bin/env python

class Map:
    def __init__(self, input):
        self.neighbours = {}
        self.paths = -1

    def connect(self, cave1, cave2):
        n1 = self.neighbours.get(cave1, [])
        n2 = self.neighbours.get(cave2, [])

        if cave2 not in n1:
            n1.append(cave2)
        if cave1 not in n2:
            n2.append(cave1)

        self.neighbours[cave1] = n1
        self.neighbours[cave2] = n2

    def visit(self, cave, path):
        if cave == 'end':
            self.paths += 1
        else:
            for n in self.neighbours[cave]:
                if n.casefold() not in path:
                    self.visit(n, path + [cave])

    def count_paths(self):
        if self.paths >= 0:
            return self.paths

        self.paths = 0
        self.visit('start', [])
        return self.paths

    def __str__(self):
        s = f"<{self.__class__.__name__} ({self.paths}):\n"
        for cave, neighbours in self.neighbours.items():
            s += f"{cave} -> {neighbours}\n"
        s += ">"
        return s


map = Map(input)

input = [list(line.split("-")) for line in open('12.input').readlines()]
for conn in input:
    map.connect(conn[0].strip(), conn[1].strip())

print(map.count_paths())
