#!/usr/bin/env python

import re
import sys

instructions = [insn.strip() for insn in open('2.input').readlines()]

instruction_format = re.compile("(?P<inst>forward|down|up) (?P<oper>[0-9]+)")


class Submarine:
    def __init__(self):
        self.horiz_pos = 0
        self.depth = 0

    def forward(self, steps):
        self.horiz_pos += steps

    def down(self, steps):
        self.depth += steps

    def up(self, steps):
        self.depth -= steps
        if self.depth < 0:
            print(f"Illegal direction: up {steps}")
            sys.exit()

    def __str__(self):
        return f"<{self.__class__.__name__}: ({self.horiz_pos}, {self.depth})>"


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
