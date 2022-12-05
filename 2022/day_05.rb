#!/usr/bin/env ruby

def part1(board, move_data)
  move_data.each do |(cnt, from, to)|
    board[to] += board[from].pop(cnt).reverse
  end

  board.sort_by { |k, v| k }.map { |k, v| v.last }.join
end


def part2(board, move_data)
  move_data.each do |(cnt, from, to)|
    board[to] += board[from].pop(cnt)
  end

  board.sort_by { |k, v| k }.map { |k, v| v.last }.join
end


data = IO.readlines(ARGV[0], chomp: true)
chunks = data.chunk { |e| e == '' }.to_a
board_data = chunks[0][1].reverse
move_data = chunks[2][1]

R = /move (\d+) from (\d+) to (\d+)/
move_data = move_data.map { |s| R.match(s).captures.map(&:to_i) }

# Dont have deep_dup so lets just build a board for each part
board1 = Hash.new { |h, k| h[k] = [] }
board2 = Hash.new { |h, k| h[k] = [] }

# we've flipped the data as its easier to use the empty space as the end
# condition.
# Look for a character when we find one the data is at the same index above it
board_data.first.chars.each_with_index do |char, col|
  next if char == ' '
  col_int = col

  board_data[1,99999].each do |row|
    v = row[col]
    break if v == ' '
    board1[char.to_i] << v
    board2[char.to_i] << v
  end
end

p part1(board1, move_data)
p part2(board2, move_data)
