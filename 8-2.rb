#!/usr/bin/env ruby

lines = File.read('8.input').lines.map { |l| l.split '|' }.map { |l| [l[0].split, l[1].split] }

outputs = []

# Segments:
#
#  000
# 1   2
# 1   2
#  333
# 4   5
# 4   5
#  666

numerals = {
  '012456' => '0',
  '25' => '1',
  '02346' => '2',
  '02356' => '3',
  '1235' => '4',
  '01356' => '5',
  '013456' => '6',
  '025' => '7',
  '0123456' => '8',
  '012356' => '9'
}

lines.each do |line|
  value = line.flatten.map { |s| s.split('').sort.join('') }
  output = line[1].map { |s| s.split('').sort.join('') }

  possibles = {}
  'a'.upto('g') do |i|
    possibles[i] = []
    '0'.upto('6') { |n| possibles[i].append n }
  end

  one = value.find { |s| s.size == 2 }
  four = value.find { |s| s.size == 4 }
  seven = value.find { |s| s.size == 3 }

  one.split('').each { |x| possibles[x] &= ['2', '5'] } if one
  four.split('').each { |x| possibles[x] &= ['1', '2', '3', '5'] } if four
  seven.split('').each { |x| possibles[x] &= ['0', '2', '5'] } if seven

  if one and seven
    seven_flag = seven.split('') - one.split('')
    possibles[seven_flag[0]] &= ['0']
  end

  # Five segments: 2, 5, or 3. Common segments: 0, 3, 6
  five_segments = value.select { |v| v.size == 5 }
  common_five_segments = five_segments.reduce(['a', 'b', 'c', 'd', 'e', 'f', 'g']) { |memo, s| memo & s.split('') }
  common_five_segments.each { |x| possibles[x] &= ['0', '3', '6'] }

  # Six segments: 0, 6, or 9. Common segments: 0, 1, 5, 6
  six_segments = value.select { |v| v.size == 6 }
  common_six_segments = six_segments.reduce(['a', 'b', 'c', 'd', 'e', 'f', 'g']) { |memo, s| memo & s.split('') }
  common_six_segments.each { |x| possibles[x] &= ['0', '1', '5', '6'] }

  definites = {}

  loop do
    changed = false

    # Find any lines which can only lead to one possible segment, move
    # them from "possibles" to "definites".
    possibles.each do |key, v|
      if v.size == 1
        definites[key] = v.first
        changed = true
      end
    end
    definites.each_key { |k| possibles.delete k }

    # Remove any definitely known lines from each list of possibles.
    definites.each_value do |d|
      possibles.each_key do |k|
        possibles[k] -= [d]
      end
    end

    # Loop until a steady state.
    break unless changed
  end

  out = ''

  output.each do |numeral|
    segments = numeral.split('')
    mapped = segments.map { |s| definites[s] }.sort.join ''
    out += numerals[mapped]
  end
  outputs.append out.to_i
end

print outputs.sum, "\n"
