#!/usr/bin/env ruby

def main(file)
  lines = IO.readlines(file, chomp: true)
  all_board = Hash.new { |h, k| h[k] = 0 }
  straight_board = Hash.new { |h, k| h[k] = 0 }
  pattern = /(\d+),(\d+) -> (\d+),(\d+)/

  lines.each do |line|
    x1, y1, x2, y2 = line.match(pattern).captures.map(&:to_i)

    x_add = (x2 - x1) <=> 0
    y_add = (y2 - y1) <=> 0

    straight = x_add == 0 || y_add == 0

    loop do
      all_board[[x1,y1]] += 1
      straight_board[[x1,y1]] += 1 if straight

      break if (x1 == x2 && y1 == y2)
      x1 += x_add
      y1 += y_add
    end
  end

  puts "Straight intersections: #{straight_board.values.count { |x| x > 1 } }"
  puts "All intersections: #{all_board.values.count { |x| x > 1 } }"
end


main(ARGV[0])

