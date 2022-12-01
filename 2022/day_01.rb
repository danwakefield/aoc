#!/usr/bin/env ruby

def part1(data)
  data.map(&:sum).max
end

def part2(data)
  data.map(&:sum).sort.last(3).sum
end


data = IO.readlines(ARGV[0], chomp: true).map(&:to_i)
data = data
  .chunk(&:zero?)
  .select { |(zero, _)| !zero }
  .map { _2 }

p part1(data)
p part2(data)
