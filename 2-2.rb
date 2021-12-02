#!/usr/bin/env ruby

instructions = File.read('2.input').lines.map(&:strip)

instruction_format = /(?<inst>forward|down|up) (?<oper>[[:digit:]]+)/

class Submarine
  attr_accessor :horiz_pos
  attr_accessor :depth
  attr_accessor :aim

  def initialize
    @horiz_pos = 0
    @depth = 0
    @aim = 0
  end

  def forward(steps)
    @horiz_pos += steps
    @depth += @aim * steps
    if @depth.negative?
      print "Illegal instruction: forward #{steps}"
      exit
    end
  end

  def down(steps)
    @aim += steps
  end

  def up(steps)
    @aim -= steps
  end

  def to_s
    "<#{self.class}: (#{@horiz_pos}, #{@depth}, #{@aim})>"
  end
end

sub = Submarine.new

instructions.each do |insn|
  instruction_format.match(insn) do |m|
    case m['inst']
    when 'forward'
      sub.forward(m['oper'].to_i)
    when 'down'
      sub.down(m['oper'].to_i)
    when 'up'
      sub.up(m['oper'].to_i)
    else
      print "Illegal instruction: #{insn}\n"
      exit
    end
  end
end

print "#{sub.horiz_pos * sub.depth}\n"
