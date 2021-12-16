#!/usr/bin/env ruby

class Packet
  attr_accessor :version
  attr_accessor :type

  def initialize(version, type)
    @version = version
    @type = type
  end

  def score
    @version
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
end

class Operator < Packet
  attr_accessor :sub_packets

  def initialize(version, type)
    super(version, type)
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

  def score
    @version + @sub_packets.map(&:score).sum
  end
end

def parse_packet(bits)
  version = bits.shift(3).join.to_i(2)
  case type = bits.shift(3).join.to_i(2)
  when 4
    packet = Literal.new(version, type)
  else
    packet = Operator.new(version, type)
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
