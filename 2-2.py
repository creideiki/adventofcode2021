#!/usr/bin/env python

import re
import sys

instructions = [insn.strip() for insn in open('2.input').readlines()]

instruction_format = re.compile("(?P<inst>forward|down|up) (?P<oper>[0-9]+)")


class Submarine:
    def __init__(self):
        self.horiz_pos = 0
        self.depth = 0
        self.aim = 0

    def forward(self, steps):
        self.horiz_pos += steps
        self.depth += self.aim * steps
        if self.depth < 0:
            print(f"Illegal direction: forward {steps}")
            sys.exit()

    def down(self, steps):
        self.aim += steps

    def up(self, steps):
        self.aim -= steps

    def __str__(self):
        return f"<{self.__class__.__name__}: ({self.horiz_pos}, {self.depth}, {self.aim})>"


sub = Submarine()

for insn in instructions:
    m = instruction_format.match(insn)
    if m['inst'] == 'forward':
        sub.forward(int(m['oper']))
    elif m['inst'] == 'down':
        sub.down(int(m['oper']))
    elif m['inst'] == 'up':
        sub.up(int(m['oper']))
    else:
        print(f"Illegal instruction: {insn}")
        sys.exit()

print(f"{sub.horiz_pos * sub.depth}")
