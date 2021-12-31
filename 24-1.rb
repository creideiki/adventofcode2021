#!/usr/bin/env ruby

require 'memoist'  # https://github.com/matthewrudy/memoist

class ALU
  attr_accessor :w, :x, :y, :z

  def initialize(input)
    @input = input.split('').map(&:to_i)
    @w = 0
    @x = 0
    @y = 0
    @z = 0
  end

  def to_s
    "<#{self.class}: input=#{@input}, w=#{@w}, x=#{@x}, y=#{@y}, z=#{@z}>"
  end

  def inspect
    to_s
  end

  def inp(reg, _)
    instance_variable_set('@' + reg, @input.shift.to_i)
  end

  def get_operand(oper)
    case oper
    when 'w'..'z'
      instance_variable_get('@' + oper)
    else
      oper.to_i
    end
  end

  def add(reg, oper)
    op1 = instance_variable_get('@' + reg)
    op2 = get_operand oper
    instance_variable_set('@' + reg, op1 + op2)
  end

  def mul(reg, oper)
    op1 = instance_variable_get('@' + reg)
    op2 = get_operand oper
    instance_variable_set('@' + reg, op1 * op2)
  end

  def div(reg, oper)
    op1 = instance_variable_get('@' + reg)
    op2 = get_operand oper
    instance_variable_set('@' + reg, (op1.to_f / op2).truncate)
  end

  def mod(reg, oper)
    op1 = instance_variable_get('@' + reg)
    op2 = get_operand oper
    instance_variable_set('@' + reg, op1 % op2)
  end

  def eql(reg, oper)
    op1 = instance_variable_get('@' + reg)
    op2 = get_operand oper
    instance_variable_set('@' + reg, op1 == op2 ? 1 : 0)
  end

  def valid?
    @z == 0
  end
end

class MONAD
  extend Memoist

  @@instruction_format = /^(?<inst>inp|add|mul|div|mod|eql) (?<reg>[w-z])($| (?<oper>([w-z]|[[:digit:]\-]+)))/

  def initialize(program)
    @blocks = []
    collect = []
    program.each do |line|
      if line.start_with? 'inp' and not collect.empty?
        @blocks.append collect
        collect = []
      end
      collect.append line
    end
    @blocks.append collect
  end

  def run_block(step, w, z)
    alu = ALU.new w.to_s
    alu.z = z
    @blocks[step].each do |insn|
      @@instruction_format.match(insn) do |m|
        alu.send m['inst'].to_sym, m['reg'], m['oper']
      end
    end
    alu.z
  end

  def find_solution(step, input, last_output)
    return '' if step == 14 and last_output.zero?
    return nil if step == 14

    this_block = step >= 0 ? run_block(step, input, last_output) : 0

    9.downto(1) do |next_input|
      solution = find_solution(step + 1, next_input, this_block)
      return input.to_s + solution if solution
    end
    nil
  end

  memoize :find_solution

  def find_max
    find_solution(-1, 0, 0)[1..]
  end
end

instructions = File.read('24.input').lines.map(&:strip)

monad = MONAD.new(instructions)

print monad.find_max, "\n"
