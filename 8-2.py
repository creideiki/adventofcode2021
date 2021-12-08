#!/usr/bin/env python

lines = [[l.split('|')[0].split(), l.split('|')[1].split()] for l in open('8.input').readlines()]

outputs = []

numerals = {
  '012456': '0',
  '25': '1',
  '02346': '2',
  '02356': '3',
  '1235': '4',
  '01356': '5',
  '013456': '6',
  '025': '7',
  '0123456': '8',
  '012356': '9'
}

for line in lines:
    value = [item for sublist in line for item in sublist]
    l = []
    for v in value:
        m = list(v)
        m.sort()
        l.append(''.join(m))
    value = l

    output = line[1]
    l = []
    for o in output:
        m = list(o)
        m.sort()
        l.append(''.join(m))
    output = l

    possibles = {}
    for i in ['a', 'b', 'c', 'd', 'e', 'f', 'g']:
        possibles[i] = set()
        for n in range(7):
            possibles[i].add(str(n))

    one = None
    for v in value:
        if len(v) == 2:
            one = v
            break

    four = None
    for v in value:
        if len(v) == 4:
            four = v
            break

    seven = None
    for v in value:
        if len(v) == 3:
            seven = v
            break

    if one is not None:
        for letter in list(one):
            possibles[letter] &= set(['2', '5'])

    if four is not None:
        for letter in list(four):
            possibles[letter] &= set(['1', '2', '3', '5'])

    if seven is not None:
        for letter in list(seven):
            possibles[letter] &= set(['0', '2', '5'])

    if one is not None and seven is not None:
        seven_flag = set(list(seven)) - set(list(one))
        possibles[list(seven_flag)[0]] &= set(['0'])

    # Five segments: 2, 5, or 3. Common segments: 0, 3, 6
    five_segments = [v for v in value if len(v) == 5]
    common_five_segments = set(['a', 'b', 'c', 'd', 'e', 'f', 'g'])
    for s in five_segments:
        common_five_segments &= set(list(s))
    for s in common_five_segments:
        possibles[s] &= set(['0', '3', '6'])

    # Six segments: 0, 6, or 9. Common segments: 0, 1, 5, 6
    six_segments = [v for v in value if len(v) == 6]
    common_six_segments = set(['a', 'b', 'c', 'd', 'e', 'f', 'g'])
    for s in six_segments:
        common_six_segments &= set(list(s))
    for s in common_six_segments:
        possibles[s] &= set(['0', '1', '5', '6'])

    definites = {}

    while True:
        changed = False

        # Find any lines which can only lead to one possible segment,
        # move them from "possibles" to "definites".
        for key, v in possibles.items():
            if len(v) == 1:
                definites[key] = list(v)[0]
                changed = True
        for k in definites.keys():
            if k in possibles:
                del possibles[k]

        # Remove any definitely known lines from each list of
        # possibles.
        for d in definites.values():
            for k in possibles.keys():
                possibles[k] -= set([d])

        # Loop until a steady state.
        if not changed:
            break

    out = ""

    for numeral in output:
        segments = list(numeral)
        l = [definites[s] for s in segments]
        l.sort()
        mapped = ''.join(l)
        out += numerals[mapped]

    outputs.append(int(out))

print(sum(outputs))
