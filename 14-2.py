#!/usr/bin/env python

from collections import deque
import re

class Polymer:
    def __init__(self, template):
        self.pairs = {}
        self.rules = {}
        self.trail = template[-1]

        for pos in range(len(template) - 1):
            pair = template[pos : pos + 2]
            self.pairs[pair] = self.pairs.get(pair, 0) + 1

    def add_rule(self, pair, insert):
        self.rules[pair] = insert

    def step(self):
        new_pairs = {}
        for pair, count in self.pairs.items():
            production = self.rules.get(pair, None)
            if production is not None:
                new_pairs[pair[0] + production] = new_pairs.get(pair[0] + production, 0) + count
                new_pairs[production + pair[1]] = new_pairs.get(production + pair[1], 0) + count
            else:
                new_pairs[pair] = count
        self.pairs = new_pairs

    def score(self):
        counts = {}
        for pair, count in self.pairs.items():
            counts[pair[0]] = counts.get(pair[0], 0) + count
        counts[self.trail] = counts.get(self.trail, 0) + 1
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

for _ in range(40):
    p.step()

print(p.score())
