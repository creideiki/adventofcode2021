#!/usr/bin/env python

from collections import deque
import re

class Polymer:
    def __init__(self, template):
        self.molecule = template
        self.rules = {}

    def add_rule(self, pair, insert):
        self.rules[pair] = insert

    def step(self):
        new_molecule = self.molecule[0]
        for pos in range(len(self.molecule) - 1):
            pair = self.molecule[pos : pos + 2]
            new_molecule += self.rules[pair] + pair[1]
        self.molecule = new_molecule

    def score(self):
        counts = {}
        for atom in self.molecule:
            counts[atom] = counts.get(atom, 0) + 1
        l = list(counts.values())
        l.sort()
        return l[-1] - l[0]

    def __str__(self):
        return f"<{self.__class__.__name__}: {self.molecule}>"


insertion_format = re.compile("(?P<pair>[A-Z]{2}) -> (?P<insert>[A-Z])")

input = deque([line.strip() for line in open('14.input').readlines()])

p = Polymer(input.popleft())

input.popleft()

for line in input:
    insertion = insertion_format.match(line)
    p.add_rule(insertion['pair'], insertion['insert'])

for _ in range(10):
    p.step()

print(p.score())
