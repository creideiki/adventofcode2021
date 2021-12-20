#!/usr/bin/env python

import numpy

class Image:
    def __init__(self, enhance, input):
        self.mapping = [0] * 512
        for i in range(len(enhance)):
            if enhance[i] == '#':
                self.mapping[i] = 1

        self.size = len(input)
        self.image = numpy.zeros((self.size, self.size), dtype=numpy.uint)

        for row in range(len(input)):
            for col in range(len(input)):
                if input[row][col] == '#':
                    self.image[row, col] = 1

        self.background = 0

    def get_pixel(self, row, col):
        if row < 0 or col < 0 or row >= self.size or col >= self.size:
            return self.background
        else:
            return self.image[row, col]

    def get_grid(self, row, col):
        num = 0
        for r in [-1, 0, 1]:
            for c in [-1, 0, 1]:
                num <<= 1
                if self.get_pixel(row + r, col + c) > 0:
                    num += 1
        return num

    def get_enhanced(self, row, col):
        return self.mapping[self.get_grid(row, col)]

    def enhance(self):
        new_size = self.size + 2
        new_image = numpy.zeros((new_size, new_size), dtype=numpy.uint)
        new_background = self.mapping[int(str(self.background) * 9, 2)]

        for row in range(new_size):
            for col in range(new_size):
                new_image[row, col] = self.get_enhanced(row - 1, col - 1)

        self.image = new_image
        self.size = new_size
        self.background = new_background

    def score(self):
        return numpy.sum(self.image)


lines = [list(line.strip()) for line in open('20.input').readlines()]

img = Image(lines[0], lines[2:])

for _ in range(50):
    img.enhance()

print(img.score())
