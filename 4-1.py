#!/bin/env python

import numpy

class Bingo:
    def __init__(self):
        self.board = numpy.zeros((5, 5), dtype=numpy.uint)
        self.marks = numpy.ones((5, 5), dtype=numpy.uint)

    def mark(self, num):
        for row in range(5):
            for col in range(5):
                if self.board[row, col] == num:
                    self.marks[row, col] = 0

    def won(self):
        for row in range(5):
            won = True
            for col in range(5):
                if self.marks[row, col] == 1:
                    won = False
                    break
            if won:
                return True

        for col in range(5):
            won = True
            for row in range(5):
                if self.marks[row, col] == 1:
                    won = False
                    break
            if won:
                return True

        return False

    def score(self):
        return int((self.board * self.marks).sum())

    def __str__(self):
        s = f"<{self.__class__.__name__}:\n"
        for row in range(5):
            for col in range(5):
                if self.marks[row, col] == 0:
                    s += "*"
                s += str(self.board[row, col])
                s += " "
            s += "\n"
        s += ">"
        return s


input = [line.strip() for line in open('4.input').readlines()]

draws = [int(d) for d in input.pop(0).split(",")]
boards = []

while len(input) > 0:
    input.pop(0)
    board = Bingo()
    for row in range(5):
        numbers = [int(n) for n in input.pop(0).split()]
        for col in range(5):
            board.board[row, col] = numbers[col]
    boards.append(board)

for draw in draws:
    for board in boards:
        board.mark(draw)
        if board.won():
            print(board.score() * draw)
            exit()
