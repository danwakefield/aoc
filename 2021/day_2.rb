#!/usr/bin/env ruby

def part1(actions)
  depth = 0
  horiz = 0

  actions.each do |action, amount|
    case action
    when "forward"
      horiz += amount
    when "down"
      depth += amount
    when "up"
      depth -= amount
    end
  end

  puts "Part 1: depth: #{depth}, horiz: #{horiz}, total: #{depth * horiz}"
end

def part2(actions)
  aim = 0
  depth = 0
  horiz = 0

  actions.each do |action, amount|
    case action
    when "forward"
      horiz += amount
      depth += amount * aim
    when "down"
      aim += amount
    when "up"
      aim -= amount
    end
  end

  puts "Part 2: depth: #{depth}, horiz: #{horiz}, total: #{depth * horiz}"
end


lines = IO.readlines(ARGV[0], chomp: true)
actions = lines.map do |l|
  parts = l.split(" ")

  [parts[0], parts[1].to_i]
end

part1(actions)
part2(actions)
