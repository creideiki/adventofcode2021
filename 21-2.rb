#!/usr/bin/env ruby

class Game
  attr_accessor :num_games
  attr_accessor :wins

  def initialize(p1, p2)
    # @num_games and @wins are hashes of [position1, score1,
    # position2, score2] -> number of games
    # @num_games are still active, @wins have ended
    @num_games = Hash.new 0
    @num_games[[p1 - 1, 0, p2 - 1, 0]] = 1

    @wins = Hash.new 0

    possible_rolls = [1, 2, 3].product([1, 2, 3]).product([1, 2, 3]).map(&:flatten).map(&:sum).sort
    num_possibilities = possible_rolls.uniq.map { |p| possible_rolls.count p }
    @rolls = possible_rolls.uniq.zip num_possibilities
  end

  def remove_wins!
    ended = []
    @num_games.each do |state, num|
      _, score1, _, score2 = state
      if score1 >= 21 or score2 >= 21
        @wins[state] += num
        ended.append state
      end
    end
    ended.each do |state|
      @num_games.delete state
    end
  end

  def go1!
    new_num_games = Hash.new 0
    @num_games.each do |state, num|
      pos1, score1, pos2, score2 = state
      @rolls.each do |roll, ways|
        new_pos1 = (pos1 + roll) % 10
        new_state = [new_pos1, score1 + new_pos1 + 1, pos2, score2]
        new_num_games[new_state] += num * ways
      end
    end
    @num_games = new_num_games
  end

  def go2!
    new_num_games = Hash.new 0
    @num_games.each do |state, num|
      pos1, score1, pos2, score2 = state
      @rolls.each do |roll, ways|
        new_pos2 = (pos2 + roll) % 10
        new_state = [pos1, score1, new_pos2, score2 + new_pos2 + 1]
        new_num_games[new_state] += num * ways
      end
    end
    @num_games = new_num_games
  end

  def num_wins(player)
    win_score_index = 1
    win_score_index = 3 if player == 1

    @wins.select { |state, _| state[win_score_index] >= 21 }.values.sum
  end

  def score
    [num_wins(0), num_wins(1)].max
  end

  def play!
    until @num_games.empty?
      go1!
      remove_wins!
      go2!
      remove_wins!
    end
  end

  def to_s
    s = "<#{self.class}:\n"
    @num_games.each do |state, num|
      pos1, score1, pos2, score2 = state
      s += "P1 at #{pos1 + 1}, score #{score1}, P2 at #{pos2 + 1}, score #{score2}: #{num} games.\n"
    end
    s += '>'
    s
  end

  def inspect
    to_s
  end
end

format = /^Player (?<player>[[:digit:]]) starting position: (?<pos>[[:digit:]]+)$/

lines = File.read('21.input').lines.map(&:strip)

players = [0, 0]
2.times do
  m = format.match(lines.shift)
  players[m['player'].to_i - 1] = m['pos'].to_i
end

game = Game.new(players[0], players[1])

game.play!

print game.score, "\n"
