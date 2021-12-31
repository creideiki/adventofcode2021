#!/usr/bin/env ruby

require 'memoist'  # https://github.com/matthewrudy/memoist

class MONAD
  extend Memoist

  @@instruction_format = /^(?<inst>inp|add|mul|div|mod|eql) (?<reg>[w-z])($| (?<oper>([w-z]|[[:digit:]\-]+)))/

  def initialize(program)
    # A program is 14 blocks of almost the same 18 instructions, with
    # three operands changing between them, on line 4 (div z), 5 (add
    # x), and 15 (add y).
    @divz = []
    @addx = []
    @addy = []
    program.each_with_index do |insn, number|
      @@instruction_format.match(insn) do |m|
        if number % 18 == 4
          @divz.append m['oper'].to_i
        elsif number % 18 == 5
          @addx.append m['oper'].to_i
        elsif number % 18 == 15
          @addy.append m['oper'].to_i
        end
      end
    end
  end

  def run_block(step, w, z)
    x = z % 26 + @addx[step]
    z = (z / @divz[step].to_f).truncate
    if x != w
      z *= 26
      z += w + @addy[step]
    end
    z
  end

  def find_solution(step, input, last_output)
    return '' if step == 14 and last_output.zero?
    return nil if step == 14

    this_block = step >= 0 ? run_block(step, input, last_output) : 0

    1.upto(9) do |next_input|
      solution = find_solution(step + 1, next_input, this_block)
      return input.to_s + solution if solution
    end
    nil
  end

  memoize :find_solution

  def find_max
    find_solution(-1, 0, 0)[1..]
  end

  def to_s
    "<#{self.class}:\ndiv z: #{@divz}\nadd x: #{@addx}\nadd y: #{@addy}\n>"
  end

  def inspect
    to_s
  end
end

instructions = File.read('24.input').lines.map(&:strip)

monad = MONAD.new(instructions)

print monad.find_max, "\n"
