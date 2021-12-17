#!/usr/bin/env python

import re

line = open('17.input').read().strip()

target_format = re.compile("^target area: x=(?P<x1>[0-9\-]+)..(?P<x2>[0-9\-]+), y=(?P<y1>[0-9\-]+)..(?P<y2>[0-9\-]+)$")

m = target_format.match(line)

x_min = int(m['x1'])
x_max = int(m['x2'])
y_min = int(m['y1'])
y_max = int(m['y2'])

# Launch y velocity =
# max velocity at crossing y=0 =
# distance between y=0 and bottom of target area minus 1 acceleration
y_vel = abs(y_min) - 1

y_steps = y_vel * 2 + 1

# Decellerate to x_vel = 0 while x is over target area, within y_steps time
# Distance travelled = (0 + x_vel) * x_vel / 2
#                 start ^    ^ end    ^ x_steps
# Where x_steps = x_vel < y_steps
x_vel = 0
for x_steps in range(y_steps):
    dist = x_steps * x_steps / 2
    if dist > x_min and dist < x_max:
        x_vel = x_steps
        break

max_height = int((y_vel + 1) * y_vel / 2)
print(max_height)
