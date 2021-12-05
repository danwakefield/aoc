#!/usr/bin/env ruby

def part1(data)
  count = data.each_cons(2).count { |a, b| b > a }
  puts "Part 1: #{count}"
end

def part2(data)
  count = data.each_cons(3).each_cons(2).count { |a, b| b.sum > a.sum }
  puts "Part 2: #{count}"
end


data = IO.readlines(ARGV[0], chomp: true).map(&:to_i)

part1(data)
part2(data)
