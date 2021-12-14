#!/usr/bin/env ruby

def day14(input, transforms, iterations)
  pair_counts = Hash.new { |h, k| h[k] = 0 }
  letter_counts = input.tally

  input.each_cons(2) { |pair| pair_counts[pair] += 1 }

  iterations.times do
    new_pair_counts = Hash.new { |h, k| h[k] = 0 }

    pair_counts.each do |k, v|
      t = transforms[k]
      if t.nil?
        new_pair_counts[k] = v
      else
        new_pair_counts[[k[0], t]] += v
        new_pair_counts[[t, k[1]]] += v
        letter_counts[t] += v
      end
    end

    pair_counts = new_pair_counts
  end

  least, most = letter_counts.minmax { |(_, a), (_, b)| a <=> b }

  most[1] - least[1]
end

def part1(input, transforms)
  day14(input, transforms, 10)
end

def part2(input, transforms)
  day14(input, transforms, 40)
end

data = IO.readlines(ARGV[0], chomp: true)

input = data[0].chars

transforms = data[2,9999999].map do |l|
  from, to = l.split(" -> ")

  [from.chars, to]
end.to_h


puts "Part1: #{part1(input, transforms)}"
puts "Part2: #{part2(input, transforms)}"
