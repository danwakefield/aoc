#!/usr/bin/env ruby

def calc_diffs(data)
  data.map do |pattern|
    orig_pattern = pattern
    end_diffs = [pattern.last]
    start_diffs = [pattern.first]

    until pattern.all? { |p| p == 0 }
      pattern = pattern.each.with_index.filter_map do |p, i|
        c = pattern[i+1]
        next nil if !c
        c - p
      end

      end_diffs << pattern.last
      start_diffs << pattern.first
    end

    {
      end: end_diffs.reverse.reduce { |a, b| a + b },
      start: start_diffs.reverse.reduce { |a, b| b - a },
    }
  end
end

def part1(data)
  calc_diffs(data).map { |h| h[:end] }.reduce(:+)
end

def part2(data)
  calc_diffs(data).map { |h| h[:start] }.reduce(:+)
end

data = IO.readlines(ARGV[0], chomp: true).map do |l|
  l.split.map(&:to_i)
end

p part1(data)
p part2(data)
