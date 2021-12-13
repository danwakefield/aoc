#!/usr/bin/env ruby

def companion(direction, fold_value, x, y)
  if direction == :y # fold up
    [fold_value - (x - fold_value), y]
  else
    [x, fold_value - (y - fold_value)]
  end
end

def day13(grid, folds)
  folds.each do |(direction, fold_value)|
    x_max = grid.keys.max_by { |k| k[0] }[0]
    y_max = grid.keys.max_by { |k| k[1] }[1]

    if direction == :y
      x_from = fold_value
      y_from = 0
    else
      x_from = 0
      y_from = fold_value
    end


    x_from.upto(x_max) do |x|
      y_from.upto(y_max) do |y|
        v = grid.delete([x,y])

        next if v.nil?

        grid[companion(direction, fold_value, x, y)] += v
      end
    end
  end

end

def part1(grid, folds)
  day13(grid, folds)

  grid.values.count { |v| v >= 1 }
end

def part2(grid, folds)
  day13(grid, folds)

  x_max = grid.keys.max_by { |k| k[0] }[0]
  y_max = grid.keys.max_by { |k| k[1] }[1]

  puts "Part 2:"
  0.upto(x_max) do |x|
    0.upto(y_max) do |y|
      if grid.include?([x,y])
        print '#'
      else
        print ' '
      end
    end
    puts
  end
end

points, _, folds = IO.readlines(ARGV[0], chomp: true).chunk_while { |a, b| a != '' && b != '' }.to_a

grid = Hash.new { |h, k| h[k] = 1 }

points.each do |point_string|
  y, x = point_string.split(",").map(&:to_i)

  grid[[x,y]] = 1
end

fold_pattern = /.*([xy])=(\d+)/
folds = folds.map do |fold_string|
  direction, value = fold_string.match(fold_pattern).captures

  [direction.to_sym, value.to_i]
end

puts "Part 1: #{part1(grid.dup, folds[0,1])}"
part2(grid.dup, folds)
