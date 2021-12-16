#!/usr/bin/env python

class Packet:
    def __init__(self, version, t):
        self.version = version
        self.t = t

    def __str__(self):
        return f"<{self.__class__.__name__}: version={self.version}, type={self.t}>"


class Literal(Packet):
    def __init__(self, version, t):
        super().__init__(version, t)
        self.data = -1

    def parse(self, bits):
        b = ''
        while True:
            cont = int(bits[0])
            group = bits[1:5]
            bits = bits[5:]
            b += ''.join(group)
            if cont == 0:
                break
        self.data = int(b, 2)
        return bits

    def score(self):
        return self.data

    def __str__(self):
        return f"<{self.__class__.__name__}: version={self.version}, type={self.t}, data={self.data}>"


class Operator(Packet):
    def __init__(self, version, t):
        super().__init__(version, t)
        self.sub_packets = []

    def parse(self, bits):
        length_type_id = int(''.join(bits[0:1]))
        bits = bits[1:]
        if length_type_id == 0:
            sub_packet_length = int(''.join(bits[0:15]), 2)
            bits = bits[15:]
            self.sub_packets = parse_packets(bits[0:sub_packet_length])
            bits = bits[sub_packet_length:]
        elif length_type_id == 1:
            num_sub_packets = int(''.join(bits[0:11]), 2)
            bits = bits[11:]
            for _ in range(num_sub_packets):
                sub_packet, bits = parse_packet(bits)
                self.sub_packets.append(sub_packet)
        return bits

    def __str__(self):
        s = f"<{self.__class__.__name__}: version={self.version}, type={self.t}, sub_packets=[\n"
        for p in self.sub_packets:
            s += str(p) + "\n"
        s += ">"
        return s


class Sum(Operator):
    def score(self):
        return sum([p.score() for p in self.sub_packets])


class Product(Operator):
    def score(self):
        score = 1
        for p in self.sub_packets:
            score *= p.score()
        return score


class Minimum(Operator):
    def score(self):
        return min([p.score() for p in self.sub_packets])


class Maximum(Operator):
    def score(self):
        return max([p.score() for p in self.sub_packets])


class GreaterThan(Operator):
    def score(self):
        if self.sub_packets[0].score() > self.sub_packets[1].score():
            return 1
        else:
            return 0


class LessThan(Operator):
    def score(self):
        if self.sub_packets[0].score() < self.sub_packets[1].score():
            return 1
        else:
            return 0

class EqualTo(Operator):
    def score(self):
        if self.sub_packets[0].score() == self.sub_packets[1].score():
            return 1
        else:
            return 0


def parse_packet(bits):
    version = int(''.join(bits[0:3]), 2)
    bits = bits[3:]
    t = int(''.join(bits[0:3]), 2)
    bits = bits[3:]
    if t == 0:
        packet = Sum(version, t)
    if t == 1:
        packet = Product(version, t)
    if t == 2:
        packet = Minimum(version, t)
    if t == 3:
        packet = Maximum(version, t)
    if t == 4:
        packet = Literal(version, t)
    if t == 5:
        packet = GreaterThan(version, t)
    if t == 6:
        packet = LessThan(version, t)
    if t == 7:
        packet = EqualTo(version, t)
    bits = packet.parse(bits)
    return (packet, bits)


def parse_packets(bits):
    packets = []
    while not all(b == '0' for b in bits):
        packet, bits = parse_packet(bits)
        packets.append(packet)
    return packets


lines = [list(line.strip()) for line in open('16.input').readlines()]
packets = []
for line in lines:
    binary = []
    for h in line:
        binary += list(format(int(h, 16), '0>4b'))
    packets.append(binary)

for p in packets:
    packet, _ = parse_packet(p)
    print(packet.score())
