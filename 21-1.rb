#!/usr/bin/env ruby

class DeterministicDie
  attr_accessor :num_rolls
  attr_accessor :state

  def initialize
    @state = 0
    @num_rolls = 0
  end

  def roll
    @num_rolls += 1
    new_state = @state + 1
    new_state = 1 if new_state == 101
    @state = new_state
  end

  def to_s
    "<#{self.class}: #{@state}>"
  end

  def inspect
    to_s
  end
end

class Game
  def initialize(die, p1, p2)
    @die = die
    @scores = [0, 0]
    @positions = [p1 - 1, p2 - 1]
  end

  def move!(player, spaces)
    @positions[player] = (@positions[player] + spaces) % 10
  end

  def go(player)
    move = 0
    3.times { |_| move += @die.roll }
    new_position = move!(player, move)
    @scores[player] += new_position + 1
    @positions[player] = new_position
  end

  def round
    go(0)
    return 0 if @scores[0] >= 1000
    go(1)
    return 1 if @scores[1] >= 1000
    false
  end

  def play
    winner = false
    loop do
      winner = round
      break if winner
    end

    return @die.num_rolls * @scores[1 - winner]
  end
end

format = /^Player (?<player>[[:digit:]]) starting position: (?<pos>[[:digit:]]+)$/

lines = File.read('21.input').lines.map(&:strip)

players = [0, 0]
2.times do
  m = format.match(lines.shift)
  players[m['player'].to_i - 1] = m['pos'].to_i
end

die = DeterministicDie.new

game = Game.new(die, players[0], players[1])

print game.play, "\n"
