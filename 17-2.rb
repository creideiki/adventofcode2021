#!/usr/bin/env ruby

input = File.read('17.input').strip

target_format = /^target area: x=(?<x1>[[:digit:]\-]+)..(?<x2>[[:digit:]\-]+), y=(?<y1>[[:digit:]\-]+)..(?<y2>[[:digit:]\-]+)$/

m = target_format.match(input)

x_min = m['x1'].to_i
x_max = m['x2'].to_i
y_min = m['y1'].to_i
y_max = m['y2'].to_i

# Possible x velocities:
# Maximum: hits x_max on the first time step
x_vel_max = x_max

# Minimum: decellerates to x_vel=0 before x_min
# Distance travelled = (1 + x_vel) * x_vel / 2
#                 start ^    ^ end    ^ x_steps
x_vel_min = 0
x_min.times do |x_vel|
  if (1 + x_vel) * x_vel / 2 >= x_min
    x_vel_min = x_vel
    break
  end
end

# Possible y velocities:
# Maximum: lobs up, hits y=0 at launch velocity, hits y=y_min at next step
y_vel_max = y_min.abs - 1

# Minimum: directly to y_min at first step
y_vel_min = y_min

def simulate(x_vel, y_vel, x_min, x_max, y_min, y_max)
  x = 0
  y = 0
  while x <= x_max and y >= y_min
    return true if
      x >= x_min and x <= x_max and
      y >= y_min and y <= y_max

    x += x_vel
    y += y_vel
    x_vel -= 1 if x_vel.positive?
    y_vel -= 1
  end
  false
end

count = 0
x_vel_min.upto(x_vel_max) do |x_vel|
  y_vel_min.upto(y_vel_max) do |y_vel|
    if simulate(x_vel, y_vel, x_min, x_max, y_min, y_max)
      count += 1
    end
  end
end
print count, "\n"
