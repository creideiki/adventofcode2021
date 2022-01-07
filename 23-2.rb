#!/usr/bin/env ruby

require 'algorithms'  # https://github.com/kanwei/algorithms v1.0.0

class State
  attr_accessor :energy
  attr_accessor :hallway
  attr_accessor :rooms
  attr_accessor :solution

  def to_s
    s  = "Energy: #{@energy}\n"
    s += "Moves: #{@solution}\n"
    s += '#############' + "\n"
    s += '#'
    @hallway.each_with_index do |h, pos|
      s += '.' if pos.between?(2, 5)
      s += (h or '.')
    end
    s += '#' + "\n"
    s += '##'
    @rooms.each { |r| s += '#' + (r[0] or '.') }
    s += '###' + "\n"
    s += '  '
    @rooms.each { |r| s += '#' + (r[1] or '.') }
    s += '#' + "\n"
    s += '  '
    @rooms.each { |r| s += '#' + (r[2] or '.') }
    s += '#' + "\n"
    s += '  '
    @rooms.each { |r| s += '#' + (r[3] or '.') }
    s += '#' + "\n"
    s += '  #########' + "\n"
    s
  end

  alias inspect to_s

  @@cost = {
    'A' => 1,
    'B' => 10,
    'C' => 100,
    'D' => 1000
  }

  @@destination = {
    'A' => 0,
    'B' => 1,
    'C' => 2,
    'D' => 3
  }

  @@hallway_coords = {
    0 => 0,
    1 => 1,
    2 => 3,
    3 => 5,
    4 => 7,
    5 => 9,
    6 => 10
  }

  @@room_coords = {
    0 => 2,
    1 => 4,
    2 => 6,
    3 => 8
  }

  def hallway_out_distance(room, hallway)
    d = 5 - @rooms[room].size
    d += (@@hallway_coords[hallway] - @@room_coords[room]).abs
    d
  end

  def hallway_in_distance(room, hallway)
    d = 4 - @rooms[room].size
    d += (@@hallway_coords[hallway] - @@room_coords[room]).abs
    d
  end

  def room_distance(source, dest)
    d = 5 - @rooms[source].size
    d += (@@room_coords[source] - @@room_coords[dest]).abs
    d += 4 - @rooms[dest].size
  end

  def initialize(rooms)
    @energy = 0
    @hallway = [nil] * 7
    @rooms = rooms.map(&:dup)
    @solution = []
  end

  def initialize_copy(other)
    @energy = other.energy
    @hallway = other.hallway.dup
    @rooms = other.rooms.map(&:dup)
    @solution = other.solution.dup
  end

  def hash
    s = @hallway.map { |p| p == nil ? '0' : p }
    s += @rooms.map do |room|
      case room.size
      when 0
        '0000'
      when 1
        '000' + room[0]
      when 2
        '00' + room[0] + room[1]
      when 3
        '0' + room[0] + room[1] + room[2]
      when 4
        room[0] + room[1] + room[2] + room[3]
      end
    end
    s.join('').to_i(16)
  end

  def finished?
    finished = hallway.all? nil
    rooms.each_index do |position|
      finished &&= @rooms[position].all? do |amphipod|
        position == @@destination[amphipod]
      end
    end
    finished
  end

  def ==(other)
    @hallway == other.hallway and @rooms == other.rooms and @energy == other.energy
  end

  alias eql? ==

  def moves
    possible_moves = []

    # Is there space in the destination rooms?
    valid_target_room = [true] * 4
    @rooms.each_with_index do |occupants, room_no|
      valid_target_room[room_no] &&= occupants.size < 4
      valid_target_room[room_no] &&= occupants.all? { |amphipod| room_no == @@destination[amphipod] }
    end

    # Is the hallway clear?
    clear_hallway = @hallway.map(&:nil?)
    clear_hallway[0] &&= @hallway[1].nil?
    clear_hallway[6] &&= @hallway[5].nil?

    # Move amphipods out of the hallway into destination rooms
    @hallway.each_with_index do |amphipod, hallway_position|
      next unless amphipod

      destination_room = @@destination[amphipod]
      # Hallway positions that need to be clear for this move to be possible
      diff = hallway_position - destination_room
      clear_range = if diff > 2  # Crossing one or more hallways to the left
                      destination_room + 2..hallway_position - 1
                    elsif diff <= 0  # Crossing one or more hallways to the right
                      hallway_position + 1..destination_room + 1
                    elsif diff == 1 and hallway_position == 0
                      1..2
                    else
                      1..0  # Room is next to hallway position, no extra clear hallway required.
                    end

      next unless amphipod and valid_target_room[destination_room] and clear_hallway[clear_range].all? true

      # We have an amphipod in the hallway, the destination has
      # space, and the hallway is clear
      moved = self.dup
      moved.hallway[hallway_position] = nil
      moved.rooms[destination_room].unshift amphipod
      moved.energy += hallway_in_distance(destination_room, hallway_position) * @@cost[amphipod]
      moved.solution.append "#{amphipod}: H#{hallway_position}->R#{destination_room}"
      possible_moves.append moved
    end

    # Move amphipods between rooms
    @rooms.each_with_index do |amphipods, source_room|
      next if amphipods.empty?
      # No amphipod will move out of this room
      next if amphipods.all? { |a| source_room == @@destination[a] }

      amphipod = amphipods[0]
      destination_room = @@destination[amphipod]
      # Hallway positions that need to be clear for this move to be possible
      clear_range = if destination_room > source_room
                      source_room + 2..destination_room + 1
                    elsif destination_room < source_room
                      destination_room + 2..source_room + 1
                    end

      next unless valid_target_room[destination_room] and clear_hallway[clear_range].all? true

      # We have an amphipod in the wrong room, the destination has
      # space, and the hallway is clear
      moved = self.dup
      moved.rooms[source_room].shift
      moved.rooms[destination_room].unshift amphipod
      moved.energy += room_distance(source_room, destination_room) * @@cost[amphipod]
      moved.solution.append "#{amphipod}: R#{source_room}->R#{destination_room}"
      possible_moves.append moved
    end

    # Move amphipods out of rooms into the hallway
    @rooms.each_with_index do |amphipods, source_room|
      next if amphipods.empty?

      # No amphipod in this room can move out
      next if amphipods.all? { |a| source_room == @@destination[a] }

      amphipod = amphipods[0]
      0.upto(6) do |hallway_position|
        # Hallway positions that need to be clear for this move to be possible
        diff = hallway_position - source_room
        clear_range = if diff > 2  # Crossing one or more hallways to the left
                        source_room + 2..hallway_position - 1
                      elsif diff <= 0  # Crossing one or more hallways to the right
                        hallway_position..source_room + 1
                      elsif diff == 1 and hallway_position == 0
                        1..2
                      else
                        1..0  # Room is next to hallway position, no extra clear hallway required.
                      end

        next unless clear_hallway[hallway_position] and clear_hallway[clear_range].all? true

        # We have an amphipod in the wrong room, and the hallway is clear
        moved = self.dup
        moved.rooms[source_room].shift
        moved.hallway[hallway_position] = amphipod
        moved.energy += hallway_out_distance(source_room, hallway_position) * @@cost[amphipod]
        moved.solution.append "#{amphipod}: R#{source_room}->H#{hallway_position}"
        possible_moves.append moved
      end
    end

    possible_moves
  end
end

map = File.read('23.input').lines.map(&:strip)
map.insert(3, '#D#C#B#A#', '#D#B#A#C#')

rooms = []
0.upto(3) do |i|
  rooms.append [map[2].delete('#')[i], map[3].delete('#')[i], map[4].delete('#')[i], map[5].delete('#')[i]]
end

start = State.new rooms
visited = Hash.new false

queue = Containers::MinHeap.new
queue.push(start.energy, start)

until queue.empty?
  state = queue.pop

  if state.finished?
    print state.energy, "\n"
    exit
  end

  state.moves.each do |move|
    unless visited.has_key? move
      queue.push(move.energy, move)
      visited[move] = true
    end
  end
end
