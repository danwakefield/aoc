#!/usr/bin/env ruby

class Packet < Struct.new(:version, :type, :value, :children, :start, :end)
  include Comparable

  def children_to_value
    {
      0 => proc { _1.sum(&:value) },
      1 => proc { _1.map(&:value).inject(:*) },
      2 => proc { _1.min.value },
      3 => proc { _1.max.value },
      5 => proc { |(a, b)| a > b ? 1 : 0 },
      6 => proc { |(a, b)| a < b ? 1 : 0 },
      7 => proc { |(a, b)| a == b ? 1 : 0 },
    }[type][children]
  end

  def <=>(other)
    value <=> other.value
  end

  def to_s(indent = 0)
    children_s = children&.map { |c| "\n" + c.to_s(indent + 2) }&.join
    "#{' ' * indent}<Packet v=#{version} type=#{type} value=#{value} #{children_s}>"
  end
end

LITERAL_TYPE = 4
LITERAL_CONTINUES = "1"
CHILDREN_BY_COUNT = "1"

def bin_to_int(x)
  x.flatten.join.to_i(2)
end

def parse_literal_value(data, packet, ptr)
  a = []

  begin
    nibble = data[ptr, 5]
    ptr += nibble.length
    break if nibble.length != 5

    a << nibble.last(4)
  end while nibble.first == LITERAL_CONTINUES

  packet.end = ptr
  packet.value = bin_to_int(a)

  return packet
end

def parse_children_by_count(data, ptr)
  children = []
  children_count = bin_to_int(data[ptr, 11])
  ptr += 11

  children_count.times do
    child_pkt = parse(data, ptr)
    children << child_pkt

    ptr = child_pkt.end
  end

  children
end

def parse_children_by_length(data, ptr)
  children = []
  children_length = bin_to_int(data[ptr, 15])
  ptr += 15

  expected_ptr = ptr + children_length

  while ptr < expected_ptr
    child_pkt = parse(data, ptr)
    children << child_pkt

    ptr = child_pkt.end
  end

  children
end

def parse(data, ptr = 0)
  start = ptr
  version = bin_to_int(data[ptr, 3])
  type = bin_to_int(data[ptr+3, 3])

  pkt = Packet.new(version, type, nil, nil, start, nil)
  ptr += 6

  if type == LITERAL_TYPE
    return parse_literal_value(data, pkt, ptr)
  end

  children_type = data[ptr]
  ptr += 1

  children = if children_type == CHILDREN_BY_COUNT
               parse_children_by_count(data, ptr)
             else
               parse_children_by_length(data, ptr)
             end

  pkt.end = children.last.end
  pkt.children = children
  pkt.value = pkt.children_to_value

  return pkt
end

def sum_versions(packet)
  total = packet.version
  packet.children&.each do |c|
    total += sum_versions(c)
  end

  total
end

def part1(data)
  pkt = parse(data)

  sum_versions(pkt)
end

def part2(data)
  pkt = parse(data)

  pkt.value
end

data = IO.readlines(ARGV[0], chomp: true).map do |l|
  l.to_i(16).to_s(2).rjust(l.length * 4, '0').chars
end

puts "Part1: #{part1(data[0])}"
puts "Part2: #{part2(data[0])}"
