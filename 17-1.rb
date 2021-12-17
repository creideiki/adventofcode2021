#!/usr/bin/env ruby

input = File.read('17.input').strip

target_format = /^target area: x=(?<x1>[[:digit:]\-]+)..(?<x2>[[:digit:]\-]+), y=(?<y1>[[:digit:]\-]+)..(?<y2>[[:digit:]\-]+)$/

m = target_format.match(input)

x_min = m['x1'].to_i
x_max = m['x2'].to_i
y_min = m['y1'].to_i
y_max = m['y2'].to_i

# Launch y velocity =
# max velocity at crossing y=0 =
# distance between y=0 and bottom of target area minus 1 acceleration
y_vel = y_min.abs - 1

y_steps = y_vel * 2 + 1

# Decellerate to x_vel = 0 while x is over target area, within y_steps time
# Distance travelled = (0 + x_vel) * x_vel / 2
#                 start ^    ^ end    ^ x_steps
# Where x_steps = x_vel < y_steps
x_vel = 0
y_steps.times do |x_steps|
  dist = x_steps * x_steps / 2
  if dist > x_min and dist < x_max
    x_vel = x_steps
    break
  end
end

max_height = (y_vel + 1) * y_vel / 2
print max_height, "\n"
