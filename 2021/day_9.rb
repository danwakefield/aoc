#!/usr/bin/env ruby

require 'set'

def neighbours(x, y, x_max, y_max)
  [
    [x+1, y],
    [x, y+1],
    [x-1, y],
    [x, y-1]
  ].reject { |(a, b)| a < 0 || b < 0 || a >= x_max || b >= y_max }
end

def part1(data)
  x_max = data.length
  y_max = data.first.length

  lower_than_neighbours_sum = 0

  (0...x_max).each do |x|
    (0...y_max).each do |y|
      e = data[x][y]

      flag = neighbours(x, y, x_max, y_max).all? { |(nx, ny)| data[nx][ny] > e }

      if flag
        lower_than_neighbours_sum += e + 1
      end
    end
  end

  lower_than_neighbours_sum
end

def part2(data)
  x_max = data.length
  y_max = data.first.length

  h = {}

  (0...x_max).each do |x|
    (0...y_max).each do |y|
      e = data[x][y]

      next if e == 9

      # Find a set from a neighbour, If none, create one
      # add current location to the set
      # assign it back to all neighbours while merging other neighbours into
      # the latest set

      valid_neighbours = neighbours(x, y, x_max, y_max).select { |nx, ny| data[nx][ny] != 9 }
      possible_sets = h.slice(*valid_neighbours)

      set = h[[x,y]] = (possible_sets.values.first || Set.new).add([x,y])
      valid_neighbours.each do |n|
        case (n_set = h[n])
        when set
          next
        when nil
          h[n] = set
        else
          h[n] = set.merge(n_set)
        end
      end
    end
  end

  h.values.uniq.map(&:length).sort.last(3).inject(:*)
end

data = IO.readlines(ARGV[0], chomp: true).map { |line| line.chars.map(&:to_i) }

puts "Part 1: #{part1(data)}"
puts "Part 2: #{part2(data)}"
