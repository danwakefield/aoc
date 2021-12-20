#!/usr/bin/env ruby

DIRECTIONS = [
  [-1, -1], [-1, 0], [-1, 1],
  [0, -1],  [0, 0],  [0, 1],
  [1, -1],  [1, 0],  [1, 1],
]

def bin_to_int(a)
  a.join.to_i(2)
end


def day20(grid, convert, times)
  x_min, x_max = grid.keys.map { _1[0] }.minmax
  y_min, y_max = grid.keys.map { _1[1] }.minmax

  times.times do |t|
    x_min -= 1 ; y_min -= 1 ; x_max += 1 ; y_max += 1

    # When the conversion string starts with '#' it means that a step converts
    # all
    # . . .
    # . . .
    # . . .
    #
    # in the infinite space into '#'.
    # convert[512] == '0'
    # so the
    # # # #
    # # # #
    # # # #
    # then turns back into '.'
    inf_default = convert[0] == '1' ?
      t % 2 == 0 ? '1' : '0' :
      '0'

    new_grid = Hash.new(inf_default)

    x_min.upto(x_max) do |x|
      y_min.upto(y_max) do |y|
        a = []
        DIRECTIONS.each do |(x_add, y_add)|
          a << grid[[x+x_add, y+y_add]]
        end

        p = new_grid[[x,y]] = convert[bin_to_int(a)]
        # print p == "1" ? "#" : "."
      end
      # puts
    end

    # puts
    grid = new_grid
  end

  grid.count { _2 == "1" }
end

conversion_string, _, image = IO.readlines(ARGV[0], chomp: true).chunk_while { _1 != '' && _2 != '' }.to_a
conversion_string = conversion_string[0].tr("#.", "10")

grid = Hash.new("0")

image.length.times do |x|
  image.first.length.times do |y|
    grid[[x, y]] = image[x][y].tr("#.", "10")
  end
end


puts "Part1: #{day20(grid.dup, conversion_string, 2)}"
puts "Part2: #{day20(grid.dup, conversion_string, 50)}"
