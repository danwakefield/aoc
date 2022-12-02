#!/usr/bin/env ruby

def beats(x)
  ((x + 1) % 3)
end

def loses(x)
  ((x + 2) % 3)
end

def part1(data)
  data.sum do |a, b|
    if a == b
      b + 3
    elsif b == beats(a)
      b + 6
    else
      b
    end
  end + data.length
end

def part2(data)
  data.sum do |a, b|
    case b
    when 0 # lose
      loses(a)
    when 1 # draw
      a + 3
    when 2 # win
      6 + beats(a)
    end
  end + data.length
end

# Instead of using 1-3 for Rock, paper, scissors; shift them down 1 so Mod 3
# works and just add 1 (data.length) to every score
VALUES = {
  'A' => 0,
  'B' => 1,
  'C' => 2,
  'X' => 0,
  'Y' => 1,
  'Z' => 2
}

data = IO.readlines(ARGV[0], chomp: true)
data = data.map { _1.split.map(&VALUES.to_proc) }

p part1(data)
p part2(data)
