#!/usr/bin/env ruby

lines = File.read('8.input').lines.map { |l| l.split '|' }.map { |l| l[1].split }

print lines.flatten.count { |s|
  case s.size
  when 2
    true
  when 4
    true
  when 3
    true
  when 7
    true
  else
    false
  end
}
print "\n"
