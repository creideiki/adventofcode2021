#!/usr/bin/env python

from math import ceil, floor

class Snailfish:
    def __init__(self, pair):
        if isinstance(pair, str):
            pair = eval(pair)
        self.pair = pair

    def __add__(self, other):
        p = Snailfish([self.pair, other.pair])
        return p.reduce()

    def reduce(self):
        while True:
            did_explode, new_pair = self.explode(self.pair)
            self.pair = new_pair
            if did_explode:
                continue

            did_split, new_pair = self.split(self.pair)
            self.pair = new_pair
            if did_split:
                continue

            break
        return self

    def increase_rightmost(self, element, increase):
        if isinstance(element, int):
            return element + increase

        return [element[0], self.increase_rightmost(element[1], increase)]

    def increase_leftmost(self, element, increase):
        if isinstance(element, int):
            return element + increase

        return [self.increase_leftmost(element[0], increase), element[1]]

    def inner_explode(self, element, level):
        if level == 5 and isinstance(element, list):
            return (True, 0, element[0], element[1])
        elif isinstance(element, int):
            return (False, element, None, None)
        else:
            new_right = element[1]

            did_explode_left, new_left, propagate_left, propagate_right = self.inner_explode(element[0], level + 1)

            if did_explode_left and propagate_right is not None and propagate_right > 0:
                new_right = self.increase_leftmost(element[1], propagate_right)
                propagate_right = 0

            did_explode_right = False
            if not did_explode_left:
                did_explode_right, new_right, propagate_left, propagate_right = self.inner_explode(element[1], level + 1)

            if did_explode_right and propagate_left is not None and propagate_left > 0:
                new_left = self.increase_rightmost(element[0], propagate_left)
                propagate_left = 0

            return (
                did_explode_left or did_explode_right,
                [new_left, new_right],
                propagate_left,
                propagate_right
            )

    def explode(self, pair):
        did_explode, new_pair, _, _ = self.inner_explode(pair, 1)
        return (did_explode, new_pair)

    def split(self, element):
        if isinstance(element, int) and element >= 10:
            return (True, [floor(element / 2), ceil(element / 2)])
        elif isinstance(element, int):
            return (False, element)
        else:
            did_split_left, new_left = self.split(element[0])
            did_split_right = False
            new_right = element[1]
            if not did_split_left:
                did_split_right, new_right = self.split(element[1])

            return (
                did_split_left or did_split_right,
                [new_left, new_right]
            )

    def magnitude(self, element):
        if isinstance(element, int):
            return element
        else:
            return 3 * self.magnitude(element[0]) + 2 * self.magnitude(element[1])

    def score(self):
        return self.magnitude(self.pair)

    def __str__(self):
        return f"<{self.__class__.__name__}: {self.pair}>"


numbers = [Snailfish(line.strip()) for line in open('18.input').readlines()]

collect = numbers[0]

for number in numbers[1:]:
    collect += number

print(collect.score())
