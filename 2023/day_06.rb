#!/usr/bin/env ruby


def part1(data)
  data = data[0].zip(data[1])

  data.map do |millis, record|
    (1..millis).map do |ms|
      velocity = ms
      leftover_time = millis - ms
      leftover_time * velocity > record
    end.count(true)
  end.reduce(:*)
end

def part2(data)
  data = data
  millis = data[0].map(&:to_s).join.to_i
  record = data[1].map(&:to_s).join.to_i

  (1..millis).map do |ms|
    velocity = ms
    leftover_time = millis - ms
    leftover_time * velocity > record
  end.count(true)
end

data = IO.readlines(ARGV[0], chomp: true).map do |l|
  a = l.split
  a.shift
  a.map(&:to_i)
end


p part1(data)
p part2(data)
