#!/usr/bin/env ruby

require 'set'
require 'matrix'

class Board
  def initialize(board)
    @data = Matrix.rows(board.map { |row| row.split.map(&:to_i) }.reject(&:empty?))
    @contains = Set[*@data.flat_map(&:itself)]
    @seen = Set.new
    @winning_number = nil
  end

  attr_reader :contains

  def mark(number)
    return false unless @winning_number.nil?
    return false unless @contains.include?(number)

    @seen.add(number)
    r, c = @data.index(number)
    @data[r, c] = -1

    if (@data.column(c).all?(&:negative?) || @data.row(r).all?(&:negative?))
      @winning_number = number
      return true
    end

    false
  end

  def score
    unseen = (@contains - @seen).sum
    unseen * @winning_number
  end
end

def main(file)
  lines = IO.readlines(file, chomp: true)
  called = lines[0].split(",").map(&:to_i)
  boards = lines[2, lines.length].chunk_while { |line| line != "" }.map { |data| Board.new(data) }
  board_lookup = Hash.new { |h, k| h[k] = Set.new }
  boards.each { |b| b.contains.each { |i| board_lookup[i].add(b) } }

  winners = []

  called.each do |number|
    round_winners = board_lookup[number].select { |b| b.mark(number) }
    winners.concat(round_winners)
    round_winners.each { |b| b.contains.each { |i| board_lookup.delete(b) } }
  end

  puts "Part 1: #{winners.first.score}"
  puts "Part 2: #{winners.last.score}"
end


main(ARGV[0])

