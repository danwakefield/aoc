#!/usr/bin/env ruby

def part1(data)
  data.values.map do |h|
    overlap = h[:win_nums] & h[:ticket_nums]

    case overlap.length
    when 0 then 0
    when 1 then 1
    else 2**(overlap.length-1)
    end
  end.reduce(:+)
end

def part2(data)
  maxK = data.keys.max

  data.each_pair do |i, h|
    overlap = h[:win_nums] & h[:ticket_nums]

    if overlap.length > 0
      ((i+1)..(i+overlap.length)).each do |wc|
        break if wc > maxK

        data[wc][:card_count] += h[:card_count]
      end
    end
  end

  data.values.sum { |h| h[:card_count] }
end

data = IO.readlines(ARGV[0], chomp: true).map.with_index(1) do |l, index|
  _, l = l.split(':')
  win_nums, ticket_nums = l.split('|')
  [
    index,
    {
      win_nums: win_nums.split.map(&:to_i),
      ticket_nums: ticket_nums.split.map(&:to_i),
      card_count: 1,
    }
  ]
end.to_h

p part1(data)
p part2(data)
