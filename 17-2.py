#!/usr/bin/env python

import re

line = open('17.input').read().strip()

target_format = re.compile("^target area: x=(?P<x1>[0-9\-]+)..(?P<x2>[0-9\-]+), y=(?P<y1>[0-9\-]+)..(?P<y2>[0-9\-]+)$")

m = target_format.match(line)

x_min = int(m['x1'])
x_max = int(m['x2'])
y_min = int(m['y1'])
y_max = int(m['y2'])

# Possible x velocities:
# Maximum: hits x_max on the first time step
x_vel_max = x_max

# Minimum: decellerates to x_vel=0 before x_min
# Distance travelled = (1 + x_vel) * x_vel / 2
#                 start ^    ^ end    ^ x_steps
x_vel_min = 0
for x_vel in range(x_min):
    if (1 + x_vel) * x_vel / 2 >= x_min:
        x_vel_min = x_vel
        break

# Possible y velocities:
# Maximum: lobs up, hits y=0 at launch velocity, hits y=y_min at next step
y_vel_max = abs(y_min) - 1

# Minimum: directly to y_min at first step
y_vel_min = y_min


def simulate(x_vel, y_vel, x_min, x_max, y_min, y_max):
    x = 0
    y = 0
    while x <= x_max and y >= y_min:
        if x >= x_min and x <= x_max and \
           y >= y_min and y <= y_max:
            return True

        x += x_vel
        y += y_vel
        if x_vel > 0:
            x_vel -= 1
        y_vel -= 1

    return False


count = 0
for x_vel in range(x_vel_min, x_vel_max + 1):
    for y_vel in range(y_vel_min, y_vel_max + 1):
        if simulate(x_vel, y_vel, x_min, x_max, y_min, y_max):
            count += 1

print(count)
