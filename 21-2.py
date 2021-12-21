#!/usr/bin/env python

from itertools import chain, product
import re

class Game:
    def __init__(self, p1, p2):
        self.num_games = {}
        self.num_games[(p1 - 1, 0, p2 - 1, 0)] = 1
        self.wins = {}

        possible_rolls = [l for l in product(product([1, 2, 3], [1, 2, 3]), [1, 2, 3])]
        possible_rolls = [a + b + c for (a, b), c in possible_rolls]
        possible_rolls.sort()
        num_possibilities = [possible_rolls.count(p) for p in list(set(possible_rolls))]
        self.rolls = list(zip(list(set(possible_rolls)), num_possibilities))

    def remove_wins(self):
        ended = []
        for state, num in self.num_games.items():
            _, score1, _, score2 = state
            if score1 >= 21 or score2 >= 21:
                self.wins[state] = self.wins.get(state, 0) + num
                ended.append(state)
        for state in ended:
            del self.num_games[state]

    def go1(self):
        new_num_games = {}
        for state, num in self.num_games.items():
            pos1, score1, pos2, score2 = state
            for roll, ways in self.rolls:
                new_pos1 = (pos1 + roll) % 10
                new_state = (new_pos1, score1 + new_pos1 + 1, pos2, score2)
                new_num_games[new_state] = new_num_games.get(new_state, 0) + num * ways
        self.num_games = new_num_games

    def go2(self):
        new_num_games = {}
        for state, num in self.num_games.items():
            pos1, score1, pos2, score2 = state
            for roll, ways in self.rolls:
                new_pos2 = (pos2 + roll) % 10
                new_state = (pos1, score1, new_pos2, score2 + new_pos2 + 1)
                new_num_games[new_state] = new_num_games.get(new_state, 0) + num * ways
        self.num_games = new_num_games

    def num_wins(self, player):
        win_score_index = 1
        if player == 1:
            win_score_index = 3
        return sum([num for state, num in self.wins.items() if state[win_score_index] >= 21])

    def score(self):
        return max([self.num_wins(0), self.num_wins(1)])

    def play(self):
        while True:
            self.go1()
            self.remove_wins()
            self.go2()
            self.remove_wins()
            if len(self.num_games) == 0:
                break


format = re.compile("^Player (?P<player>[0-9]) starting position: (?P<pos>[0-9]+)$")

lines = [line.strip() for line in open('21.input').readlines()]

players = [0, 0]
for l in range(2):
    m = format.match(lines[l])
    players[int(m['player']) - 1] = int(m['pos'])

game = Game(players[0], players[1])

game.play()

print(game.score())
