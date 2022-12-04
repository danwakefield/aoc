#!/usr/bin/env ruby

require 'pp'

def part1(data)
  data.count do |(r1, r2)|
    r1.cover?(r2) || r2.cover?(r1)
  end
end

def part2(data)
  data.count do |r1, r2|
    r1.cover?(r2.first) || r1.cover?(r2.end) || r2.cover?(r1.first) || r2.cover?(r1.end)
  end
end


data = IO.readlines(ARGV[0], chomp: true).map do |r|
  r.split(",").map do |e|
    Range.new(*e.split("-").map(&:to_i))
  end
end

p part1(data)
p part2(data)
