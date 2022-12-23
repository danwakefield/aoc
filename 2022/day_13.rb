#!/usr/bin/env ruby

require 'json'

def compare(left, right)
  if left.is_a?(Integer) && right.is_a?(Integer)
    return :equal if left == right
    return :right if left < right
    return :wrong if left > right
  end

  left = Array(left.clone)
  right = Array(right.clone)

  while !left.empty?
    r = right.shift
    # Right side was short
    return :wrong if r.nil?
    l = left.shift

    v = compare(l, r)
    return v if v != :equal
  end
  # Left side was short
  return :right if right.any?

  # equal lengths + content
  :equal
end

def part1(data)
  sum = 0
  data.each.with_index(1) do |(left, right), index|
    result = compare(left, right)
    sum += index if result == :right
  end
  sum
end

def part2(data)
  new_1 = [[2]]
  new_2 = [[6]]
  with_new_packets = data.flatten(1) + [new_1, new_2]

  sorted = with_new_packets.sort do |left, right|
    result = compare(left, right)
    next -1 if result == :right
    next 0 if result == :equal
    next 1 if result == :wrong
  end

  new_1_index = sorted.index(new_1) + 1
  new_2_index = sorted.index(new_2) + 1

  new_1_index * new_2_index
end


data = IO.readlines(ARGV[0], chomp: true)
  .chunk { |l| l == '' }
  .select { |is_empty, contents| !is_empty }
  .map { |_, contents| contents.map { |c| JSON.parse(c) } }
  .to_a

if ARGV[1] == '1'
  p part1(data)
else
  p part2(data)
end
