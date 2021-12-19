#!/usr/bin/env ruby


def part1(neighbours, path=['start'])
  c = 0

  last = path.last
  neighbours.fetch(last, []).each do |n|
    is_big = n.upcase == n

    if is_big || !path.include?(n)
      n == 'end' ?
        c += 1 :
        c += part1(neighbours, path.dup << n)
    end
  end

  c
end

def part2(neighbours, path=['start'])
  c = 0

  last = path.last
  neighbours.fetch(last, []).each do |n|
    is_small = n.downcase == n
    n == 'end' ?
      c += 1 :
      is_small && path.include?(n) ?
        c += part1(neighbours, path.dup << n) :
        c += part2(neighbours, path.dup << n)
  end

  c
end

neighbours = Hash.new { |h, k| h[k] = [] }

IO.readlines(ARGV[0], chomp: true).each do |l|
  a, b = l.split("-")

  neighbours[a] << b if b != 'start'
  neighbours[b] << a if a != 'start'
end

neighbours.delete('end')

puts "Part 1: #{part1(neighbours)}"
puts "Part 2: #{part2(neighbours)}"
