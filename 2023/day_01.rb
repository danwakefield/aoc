#!/usr/bin/env ruby

require 'strscan'

def part1(data)
  data
    .map { |l| l.gsub(/[a-z]/, '').chars } # Strip to only numbers
    .map { |l| (l[0] + l[-1]).to_i } # Turn first + last char into a number
    .reduce(:+)
end

X = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9',
}

PATTERN = /one|two|three|four|five|six|seven|eight|nine|1|2|3|4|5|6|7|8|9/

def part2(data)
  data
    .map do |l|
      line_numbers = []
      ss = StringScanner.new(l)
      until ss.eos?
        match = ss.check(PATTERN)

        line_numbers << X.fetch(match, match) unless match.nil?

        ss.pos = ss.pos + 1
      end

      # puts(l + ' - ' + line_numbers.join(', '))
      line_numbers
    end
      .map { |l| (l[0] + l[-1]).to_i } # Turn first + last char into a number
      .reduce(:+)
end

data = IO.readlines(ARGV[0], chomp: true)

p part1(data)
p part2(data)
