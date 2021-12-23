#!/usr/bin/env ruby

def part1(data)
  space = {}

  data.each do |d|
    d[:x][:from].upto(d[:x][:to]) do |x|
      d[:y][:from].upto(d[:y][:to]) do |y|
        d[:z][:from].upto(d[:z][:to]) do |z|
          space[[x,y,z]] = d[:on]
        end
      end
    end
  end

  space.count { _2 }
end


def intersect(a, b, on)
  x_from = [a[:x][:from], b[:x][:from]].max
  x_to = [a[:x][:to], b[:x][:to]].min

  y_from = [a[:y][:from], b[:y][:from]].max
  y_to = [a[:y][:to], b[:y][:to]].min

  z_from = [a[:z][:from], b[:z][:from]].max
  z_to = [a[:z][:to], b[:z][:to]].min

  if x_from > x_to || y_from > y_to || z_from > z_to
    return nil
  end

  {
    on: on,
    x: { from: x_from, to: x_to },
    y: { from: y_from, to: y_to },
    z: { from: z_from, to: z_to },
  }
end

def box_volume(b)
  (b[:x][:to] - b[:x][:from] + 1) *
    (b[:y][:to] - b[:y][:from] + 1) *
    (b[:z][:to] - b[:z][:from] + 1)
end

def part2(data)
  boxes = []

  data.each do |d|
    new_boxes = []

    boxes.each do |b|
      # if we intersect with another box, we can create a third box that is
      # the opposite action to the one we are intersecting in order to add or
      # remove it when we sum up
      new_box = intersect(b, d, !b[:on])
      new_boxes << new_box if new_box
    end

    new_boxes.each { |nb| boxes << nb }
    boxes << d if d[:on]
  end

  box_sum = 0
  boxes.each do |b|
    if b[:on]
      box_sum += box_volume(b)
    else
      box_sum -= box_volume(b)
    end
  end

  box_sum
end

PATTERN = /([^\W]+) x=(.*)\.\.(.*),y=(.*)\.\.(.*),z=(.*)\.\.(.*)/
data = IO.readlines(ARGV[0], chomp: true).map do |l|
  captures = l.match(PATTERN).captures

  {
    on: captures[0] == 'on',
    x: { from: captures[1].to_i, to: captures[2].to_i },
    y: { from: captures[3].to_i, to: captures[4].to_i },
    z: { from: captures[5].to_i, to: captures[6].to_i },
  }
end


puts "Part1: #{part1(data.reject { |d| d[:x][:from].abs > 50 })}"
puts "Part2: #{part2(data)}"
