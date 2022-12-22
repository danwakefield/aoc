#!/usr/bin/env ruby

def part1(data)
  x = 1
  sum = 0
  important_indexes = [20, 60, 100, 140, 180, 220]

  data.each.with_index(1) do |operation, index|
    if important_indexes.include?(index)
      sum += index * x
    end

    next if operation == 'noop'
    _, v = operation.split(' ')
    x += v.to_i
  end

  sum
end

def part2(data)
  x = 1
  important_indexes = [40, 80, 120, 160, 200, 240]
  final = []

  current_row = []
  # we want to draw at postition 1 when we are drawing subsequent rows we
  # subtract the important index instead of messing with row counts
  sub = 0

  data.each.with_index(1) do |operation, index|
    if (x-1..x+1).cover?(index-sub-1)
      current_row << '#'
    else
      current_row << '.'
    end

    if important_indexes.include?(index)
      final << current_row
      current_row = []
      sub = index
    end

    next if operation == 'noop'
    _, v = operation.split(' ')
    x += v.to_i
  end

  final.map(&:join).join("\n")
end


data = IO.readlines(ARGV[0], chomp: true)
# Just insert noops before each addx. Then the index is the clock cycle
new_data = []
data.each do |l|
  new_data << 'noop' if l.start_with?('addx')
  new_data << l
end

p part1(new_data)
puts part2(new_data)
