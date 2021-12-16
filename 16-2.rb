#!/usr/bin/env ruby

class Packet
  attr_accessor :version
  attr_accessor :type

  def initialize(version, type)
    @version = version
    @type = type
  end
end

class Literal < Packet
  attr_accessor :data

  def initialize(version, type)
    raise "Literal with type #{type}" if type != 4

    super(version, type)
    @data = -1
  end

  def parse(bits)
    bin = ''
    loop do
      group = bits.shift(5)
      cont = group.shift.to_i(2)
      bin += group.join
      break if cont.zero?
    end
    @data = bin.to_i(2)
    bits
  end

  def score
    @data
  end
end

class Operator < Packet
  attr_accessor :sub_packets

  def initialize(version, type)
    super(version, type)
    @type = type
    @sub_packets = []
  end

  def parse(bits)
    case length_type_id = bits.shift.to_i(2)
    when 0
      sub_packet_length = bits.shift(15).join.to_i(2)
      @sub_packets = parse_packets bits.shift(sub_packet_length)
    when 1
      num_sub_packets = bits.shift(11).join.to_i(2)
      num_sub_packets.times do
        @sub_packets.append parse_packet(bits)
      end
    end
    bits
  end
end

class Sum < Operator
  def score
    @sub_packets.map(&:score).sum
  end
end

class Product < Operator
  def score
    @sub_packets.map(&:score).reduce(1, :*)
  end
end

class Minimum < Operator
  def score
    @sub_packets.map(&:score).min
  end
end

class Maximum < Operator
  def score
    @sub_packets.map(&:score).max
  end
end

class GreaterThan < Operator
  def score
    return 1 if @sub_packets[0].score > @sub_packets[1].score
    0
  end
end

class LessThan < Operator
  def score
    return 1 if @sub_packets[0].score < @sub_packets[1].score
    0
  end
end

class EqualTo < Operator
  def score
    return 1 if @sub_packets[0].score == @sub_packets[1].score
    0
  end
end

def parse_packet(bits)
  version = bits.shift(3).join.to_i(2)
  case type = bits.shift(3).join.to_i(2)
  when 0
    packet = Sum.new(version, type)
  when 1
    packet = Product.new(version, type)
  when 2
    packet = Minimum.new(version, type)
  when 3
    packet = Maximum.new(version, type)
  when 4
    packet = Literal.new(version, type)
  when 5
    packet = GreaterThan.new(version, type)
  when 6
    packet = LessThan.new(version, type)
  when 7
    packet = EqualTo.new(version, type)
  else
    raise "Unknown packet type #{type}"
  end
  packet.parse(bits)
  packet
end

def parse_packets(bits)
  packets = []
  until bits.all? '0'
    packets.append parse_packet(bits)
  end
  packets
end

packets = File.read('16.input').lines.map(&:strip).map { |l| l.split('').map { |c| c.to_i(16).to_s(2).rjust(4, '0').split '' }.flatten }

packets.each do |p|
  print parse_packet(p).score, "\n"
end
