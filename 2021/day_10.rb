#!/usr/bin/env ruby


PART_1_POINTS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

PART_2_POINTS = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

PAIRS = {
  '[' => ']',
  '(' => ')',
  '{' => '}',
  '<' => '>'
}

def pair?(a, b)
  PAIRS[a] == b
end

def unmatched(line)
  stack = []

  line.each do |c|
    case c
    when *PAIRS.keys
      stack.push(c)
    when *PAIRS.values
      last_open = stack.pop

      return [:corrupt, c] unless pair?(last_open, c)
    else
      raise "Unknown char #{c}"
    end
  end

  [:incomplete, stack.reverse]
end

def part1(data)
  score = data.
    map(&method(:unmatched)).
    select { |t, _| t == :corrupt }.
    map { |_, x| PART_1_POINTS[x] }.
    sum

  score
end

def part2(data)
  scores = data.
    map(&method(:unmatched)).
    select { |t, _| t == :incomplete }.
    map { |_, x| x.map(&PAIRS.to_proc) }.
    map { |x| x.inject(0) { |sum, c| (sum * 5) + PART_2_POINTS[c] } }.
    sort

  score = scores[scores.length/2]

  score
end

data = IO.readlines(ARGV[0], chomp: true).map(&:chars)

puts "Part 1: #{part1(data)}"
puts "Part 2: #{part2(data)}"
