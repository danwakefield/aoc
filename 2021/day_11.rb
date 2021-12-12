#!/usr/bin/env ruby

require 'set'

def neighbours(x, y, x_max, y_max)
  [
    [x+1, y],
    [x, y+1],
    [x-1, y],
    [x, y-1],

    # diagonals
    [x-1, y-1],
    [x+1, y+1],
    [x+1, y-1],
    [x-1, y+1],
  ].reject { |(nx, ny)| nx < 0 || ny < 0 || nx > x_max || ny > y_max }
end


def flash(x, y, x_max, y_max, grid)
  flashed = []

  neighbours(x, y, x_max, y_max).each do |n|
    v = grid[n]

    if v == 9
      grid[n] = 0
      flashed << n
    elsif v > 0
      grid[n] += 1
    end
  end

  flashed.each {|f| flash(*f, x_max, y_max, grid) }
end


def part1(data, x_max, y_max, interations)
  grid = data
  flash_count = 0

  interations.times do
    flashed = []

    grid = grid.to_h do |k, v|
      if v == 9
        flashed << k
        [k, 0]
      else
        [k, v+1]
      end
    end

    flashed.each {|f| flash(*f, x_max, y_max, grid) }
    flash_count += grid.values.count(&:zero?)
  end

  flash_count
end

def part2(data, x_max, y_max)
  x = 0
  target = data.length
  grid = data

  loop do
    flashed = []
    x += 1

    grid = grid.to_h do |k, v|
      if v == 9
        flashed << k
        [k, 0]
      else
        [k, v+1]
      end
    end

    flashed.each {|f| flash(*f, x_max, y_max, grid) }
    break if grid.values.count(&:zero?) == target
  end

  require 'pry'; binding.pry
  x
end

data = {}
x_max = 0
y_max = 0

IO.readlines(ARGV[0], chomp: true).each_with_index do |l, x|
  l.chars.each_with_index do |c, y|
    data[[x,y]] = c.to_i
    y_max = y
  end
  x_max = x
end

puts "Part 1: #{part1(data, x_max, y_max, ARGV[1].to_i)}"
puts "Part 2: #{part2(data, x_max, y_max)}"
