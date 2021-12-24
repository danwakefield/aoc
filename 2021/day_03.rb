#!/usr/bin/env ruby


def part1(file)
  lines = IO.readlines(file, chomp: true)
  counted_bits = lines.map(&:chars).transpose.map(&:tally)

  gamma = []
  epsilon = []

  counted_bits.each do |h|
    min, max = h.minmax_by { |x| x[1] }

    gamma << min.first
    epsilon << max.first
  end

  gamma = gamma.join.to_i(2)
  epsilon = epsilon.join.to_i(2)

  puts "Part 1: #{gamma * epsilon}"
end

def count_index_bits(candidates)
  h = Hash.new { |h, k| h[k] = { "0" => 0, "1" => 0 } }

  candidates.each do |c|
    c.chars.each_with_index do |c, i|
      h[i][c] += 1
    end
  end

  h
end


def part2(file)
  lines = IO.readlines(file, chomp: true)
  o2 = nil
  co2 = nil

  # Pull in a trie? Not in the standard lib though
  candidates = lines.dup
  index = 0
  while o2 == nil
    min, max = count_index_bits(candidates)[index].minmax_by { |x| x[1] }
    next_bit = if max[1] == min[1]
                 "1"
               else
                 max[0]
               end

    candidates = candidates.select { |c| c[index] == next_bit }
    o2 = candidates.first if candidates.length == 1
    index += 1
  end

  candidates = lines.dup
  index = 0
  while co2 == nil
    min, max = count_index_bits(candidates)[index].minmax_by { |x| x[1] }
    next_bit = if max[1] == min[1]
                 "0"
               else
                 min[0]
               end

    candidates = candidates.select { |c| c[index] == next_bit }
    co2 = candidates.first if candidates.length == 1
    index += 1
  end

  puts "Part 2: #{o2.to_i(2) * co2.to_i(2)}"
end


part1(ARGV[0])
part2(ARGV[0])

