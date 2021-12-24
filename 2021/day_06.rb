#!/usr/bin/env ruby

require 'set'

SPAWNED = 6
NEW_FISH = 8

def part1(data, days)
  # Index -> new value
  transform = [SPAWNED, 0, 1, 2, 3, 4, 5, 6, 7]

  days.times do |day|
    new_fish_count = 0
    data = data.map do |d|
      new_value = transform[d]
      new_fish_count += 1 if d == 0

      new_value
    end

    data.concat([NEW_FISH] * new_fish_count)
  end

  data.length
end

MEMO = {}
def spawns(age, days_remaining)
  MEMO.fetch([age, days_remaining]) do |k|
    MEMO[k] = if days_remaining > age
                1 +
                  spawns(SPAWNED, days_remaining - (age + 1)) +
                  spawns(NEW_FISH, days_remaining - (age + 1))
              else
                0
              end
  end
end

def part2(data, days)
  x = data.map { |d| spawns(d, days) }
  x.sum + x.length
end

data = IO.readlines(ARGV[0], chomp: true)[0].split(",").map(&:to_i)
days = ARGV[1].to_i

if days < 100
  puts "Part 1: #{part1(data, days)}"
end

puts "Part 2: #{part2(data, days)}"
