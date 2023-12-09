#!/usr/bin/env ruby

class RangeMapper < Range
  def initialize(x, y, c)
    @mapped_range_start = x
    super(y, y + c, exclude_end = true)
  end

  def convert(x)
    offset_from_start = x - self.first
    @mapped_range_start + offset_from_start
  end
end

def part1(seeds, transforms)
  seeds.map do |s|
    transforms.each do |ts|
      matching_transform = ts.find { |t| t.cover?(s) }
      s = matching_transform.convert(s) if matching_transform
    end

    s
  end.min
end

def part2(seeds, transforms)
  smallest = Float::INFINITY

  seeds.each_cons(2) do |seed_start, seed_length|
    Range.new(seed_start, seed_start + seed_length, true).each do |s|
      transforms.each do |ts|
        matching_transform = ts.find { |t| t.cover?(s) }
        s = matching_transform.convert(s) if matching_transform
      end

      smallest = s if s < smallest
    end
  end
end

PATTERN = /(\d+) (\d+) (\d+)/.freeze

data = IO.readlines(ARGV[0], chomp: true).map do |l|
  if l.start_with?('seeds:')
    a = l.split(' ')
    a.shift
    next a.map(&:to_i)
  end
  next nil if l == ''
  next nil if l.match?(/:/)

  md = l.match(PATTERN)

  RangeMapper.new(*md.captures.map(&:to_i))
end

seeds = data.shift
transforms = data.chunk { |x| x.nil? }.reject { |(is_nils, _)| is_nils }.map { |_, x| x }

p part1(seeds, transforms)
p part2(seeds, transforms)
