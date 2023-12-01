#!/usr/bin/env ruby

def move(board, x, y, direction)
  new_x, new_y = case direction
                 when :up
                   [x, y-1]
                 when :down
                   [x, y+1]
                 when :left
                   [x-1, y]
                 when :right
                   [x+1, y]
                 end
  wraps = new_x < 0 || new_x > BOARD_X || new_y < 0 || new_y > BOARD_Y || board[new_x][new_y] == ' '

  if wraps
    new_x, new_y = case direction
                  when :up
                    [x, ]
                  when :down
                    [x, ]
                  when :left
                    [BOARD_X - board[y].reverse.index { |c| c != ' ' }, y]
                  when :right
                    [board[y].index { |c| c != ' ' }, y]
                  end
  end
end

def part1(data)
end

def part2(data)
end


data = IO.readlines(ARGV[0], chomp: true)
split_index = data.index("")
board = data[0,split_index]
path = data[split_index+1,1][0]
path = path.split(/(R|L)/).map { |p| (p == 'R' || p == 'L') ? p.to_sym : p.to_i }

BOARD_X = board.first.size
BOARD_Y = board.size

pp path

p part1(data)
p part2(data)
