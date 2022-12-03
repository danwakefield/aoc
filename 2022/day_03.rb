#!/usr/bin/env ruby

ORD_UPPER = 'A'.ord - 1 - 26
ORD_LOWER = 'a'.ord - 1
Z_ORD = 'Z'.ord

# a-z == 1-26 | A-Z == 27-52
def letter_score(letter)
  o = letter.ord
  o > Z_ORD ? o - ORD_LOWER : o - ORD_UPPER
end

def part1(data)
  data.sum do |d|
    half = d.length/2

    common = d[0, half] & d[half, half]
    common.sum(&method(:letter_score))
  end
end

def part2(data)
  data.each_slice(3).sum do |(a, b, c)|
    common = a & b & c

    common.sum(&method(:letter_score))
  end
end


data = IO.readlines(ARGV[0], chomp: true).map(&:chars)

p part1(data)
p part2(data)
