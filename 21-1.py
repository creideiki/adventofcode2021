#!/usr/bin/env python

import re

class DeterministicDie:
    def __init__(self):
        self.state = 0
        self.num_rolls = 0

    def roll(self):
        self.num_rolls += 1
        new_state = self.state + 1
        if new_state == 101:
            new_state = 1
        self.state = new_state
        return self.state


class Game:
    def __init__(self, die, p1, p2):
        self.die = die
        self.scores = [0, 0]
        self.positions = [p1 - 1, p2 - 1]

    def move(self, player, spaces):
        self.positions[player] = (self.positions[player] + spaces) % 10
        return self.positions[player]

    def go(self, player):
        move = 0
        for _ in range(3):
            move += self.die.roll()
        new_position = self.move(player, move)
        self.scores[player] += new_position + 1
        self.positions[player] = new_position

    def round(self):
        self.go(0)
        if self.scores[0] >= 1000:
            return 0
        self.go(1)
        if self.scores[1] >= 1000:
            return 1
        return None

    def play(self):
        winner = None
        while True:
            winner = self.round()
            if winner is not None:
                break

        return self.die.num_rolls * self.scores[1 - winner]


format = re.compile("^Player (?P<player>[0-9]) starting position: (?P<pos>[0-9]+)$")

lines = [line.strip() for line in open('21.input').readlines()]

players = [0, 0]
for l in range(2):
  m = format.match(lines[l])
  players[int(m['player']) - 1] = int(m['pos'])

die = DeterministicDie()

game = Game(die, players[0], players[1])

print(game.play())
