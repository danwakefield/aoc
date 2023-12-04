#!/usr/bin/env ruby

def part1(data, maxes: { 'red' => 12, 'blue' => 14, 'green' => 13 })
  total = 0

  data.each do |(game_num, colors_seen)|
    any_above = colors_seen.any? do |(color, color_counts)|
      maxes[color] < color_counts.max
    end

    total += game_num unless any_above
  end

  total
end

def part2(data)
  data.map do |(_, colors_seen)|
    colors_seen.values.map(&:max).reduce(:*)
  end.reduce(:+)
end

data = IO.readlines(ARGV[0], chomp: true)
data = data.map.with_index(1) do |l, index|
  _game, parts = l.split(':')

  h = Hash.new { |h, k| h[k] = [] }

  parts.tr(',', '').split(';').each do |p|
    x = p.split(' ')
    x.each_slice(2) do |color_count, color|
      h[color] << color_count.to_i
    end
  end

  [index, h]
end.to_h

p part1(data)
p part2(data)
