#!/usr/bin/env ruby


def part1(data)
  data = data.sort
  median = data[data.length / 2]
  data.sum { |x| (median - x).abs }
end

def part2(data)
  target = data.sum / data.length

  data.sum do |x|
    next 0 if x == target

    n = (target - x).abs

    # https://en.wikipedia.org/wiki/Triangular_number
    (n * (n+1)) / 2
  end
end

data = IO.readlines(ARGV[0], chomp: true).first.split(",").map(&:to_i)

puts "Part 1: #{part1(data)}"
puts "Part 2: #{part2(data)}"
