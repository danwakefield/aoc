#!/usr/bin/env ruby


TouchedNumberTracker = Struct.new(:number, :touched, keyword_init: true)

MOVEMENTS = [-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]

def all_adjacent(r, c)
  MOVEMENTS.map do |mr, mc|
    [r + mr, c + mc]
  end
end

def part1(num_positions, part_positions, all_nums)
  part_positions.each do |r, c, _|
    all_adjacent(r, c).each do |ar, ac|
      num_tracker = num_positions[ar][ac]
      num_tracker&.touched = true
    end
  end

  all_nums.filter(&:touched).sum(&:number)
end

def part2(num_positions, part_positions, all_nums)
  part_positions.map do |r, c, part_type|
    next unless part_type == '*'

    adjacent_nums = all_adjacent(r, c).map do |ar, ac|
      num_positions[ar][ac]
    end.compact.uniq

    if adjacent_nums.length == 2
      adjacent_nums.map(&:number).reduce(:*)
    else
      nil
    end
  end.compact.reduce(:+)
end

all_nums = []
num_positions = Hash.new { |h, k| h[k] = {} }
part_positions = []

NUM_PATTERN = /(\d+)/
PART_PATTERN = /[^.]/

data = IO.readlines(ARGV[0], chomp: true)
data.each.with_index(0) do |l, r|
  # StringScanner would probably have been good but W/E
  while (matchdata = l.match(NUM_PATTERN))
    num_tracker = TouchedNumberTracker.new(number: matchdata[0].to_i, touched: false)
    all_nums << num_tracker

    range = (matchdata.begin(0)..(matchdata.end(0)-1))
    range.each { |c| num_positions[r][c] = num_tracker }
    l[range] = '.' * range.size
  end

  while (matchdata = l.match(PART_PATTERN))
    part_positions << [r, matchdata.begin(0), matchdata[0]]
    l[matchdata.begin(0)] = '.'
  end
end

p part1(num_positions, part_positions, all_nums)
p part2(num_positions, part_positions, all_nums)
