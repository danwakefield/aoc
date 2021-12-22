#!/usr/bin/env ruby

def part1(data)
  space = {}

  data.each do |d|
    d[:x][:from].upto(d[:x][:to]) do |x|
      d[:y][:from].upto(d[:y][:to]) do |y|
        d[:z][:from].upto(d[:z][:to]) do |z|
          space[[x,y,z]] = d[:on]
        end
      end
    end
  end

  space.count { _2 }
end

def part2
end

PATTERN = /([^\W]+) x=(.*)\.\.(.*),y=(.*)\.\.(.*),z=(.*)\.\.(.*)/
data = IO.readlines(ARGV[0], chomp: true).map do |l|
  captures = l.match(PATTERN).captures

  {
    on: captures[0] == 'on',
    x: { from: captures[1].to_i, to: captures[2].to_i },
    y: { from: captures[3].to_i, to: captures[4].to_i },
    z: { from: captures[5].to_i, to: captures[6].to_i },
  }
end


puts "Part1: #{part1(data.reject { |d| d[:x][:from].abs > 50 })}"
puts "Part2: #{part2}"
