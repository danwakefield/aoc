#!/usr/bin/env ruby

require 'set'

HERDS = [
  RIGHT = ">",
  DOWN = "v",
  EMPTY = ".",
]

def part1(data, limit=nil)
  x_max = data.length
  y_max = data.first.length

  neighbours = {
    RIGHT => proc { |x, y| [x, (y + 1) % y_max] },
    DOWN => proc { |x, y| [(x + 1) % x_max, y] },
  }

  puts "Initial State"
  data.each { |nd| puts nd.join }
  puts

  moved = true
  loop_count = 0
  while moved
    moves = Set.new
    moved = false
    loop_count += 1

    0.upto(x_max-1) do |x|
      0.upto(y_max-1) do |y|
        next if data[x][y] != RIGHT

        n_x, n_y = neighbours[RIGHT][x,y]

        if data[n_x][n_y] == EMPTY
          moves.add([x, y, n_x, n_y])
        end
      end
    end

    moves.each do |(x, y, n_x, n_y)|
      moved = true
      data[x][y] = EMPTY
      data[n_x][n_y] = RIGHT
    end

    moves = Set.new

    0.upto(x_max-1) do |x|
      0.upto(y_max-1) do |y|
        next if data[x][y] != DOWN

        n_x, n_y = neighbours[DOWN][x,y]

        if data[n_x][n_y] == EMPTY
          moves.add([x, y, n_x, n_y])
        end
      end
    end

    moves.each do |(x, y, n_x, n_y)|
      moved = true
      data[x][y] = EMPTY
      data[n_x][n_y] = DOWN
    end

    # puts "After #{loop_count}"
    # data.each { |nd| puts nd.join }
    # puts

    break if loop_count == limit
  end

  loop_count
end

data = IO.readlines(ARGV[0], chomp: true).map { |l| l.chars }


puts "Part1: #{part1(data, ARGV[1].to_i)}"
