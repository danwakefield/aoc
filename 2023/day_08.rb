#!/usr/bin/env ruby

require 'pp'
require 'prime'

def part1(directions, data)
  looped_directions = directions.cycle

  node = 'AAA'
  return if data[node] == nil

  steps = 0
  looped_directions.each.with_index(1) do |dir, index|
    node = data[node][dir]

    if node == 'ZZZ'
      steps = index
      break
    end
  end

  steps
end

def gcd(a, b)
    while b != 0
      t = b
      b = a % b
      a = t
    end
    return a
  end

def part2(directions, data)
  looped_directions = directions.cycle

  pathings = data.keys.filter { |k| k.end_with?('A') }
  pathings_size = pathings.size
  first_instance_of_z = {}

  looped_directions.each.with_index(1) do |dir, step_index|
    pathings = pathings.each_with_index.map do |p, path_index|
      new_path = data[p][dir]
      if new_path.end_with?('Z')
        first_instance_of_z[path_index] ||= step_index
      end
      new_path
    end

    break if first_instance_of_z.length == pathings_size
  end

  puts first_instance_of_z

  first_instance_of_z
    .values
    .reduce(1) { |lcm, s| lcm.lcm(s) }
end

PATTERN = /(.{3}) = \((.{3}), (.{3})/

data = IO.readlines(ARGV[0], chomp: true)
directions = data.shift.tr("LR", '01').chars.map(&:to_i)
data.shift

data = data.map do |l|
  md = l.match(PATTERN)

  [md[1], [md[2], md[3]]]
end.to_h


p part1(directions, data)
p part2(directions, data)
