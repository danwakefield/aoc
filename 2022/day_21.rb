#!/usr/bin/env ruby

def reduce(h, v)
  return h[v] if h[v].is_a?(Integer)

  l, op, r = h[v]
  lv = reduce(h, l)
  rv = reduce(h, r)

  new_val = case op
            when '*'
              lv * rv
            when '-'
              lv - rv
            when '+'
              lv + rv
            when '/'
              lv / rv
            end
  h[v] = new_val
end

def part1(data)
  reduce(data, 'root')
end

def part2(data)
end


data = IO.readlines(ARGV[0], chomp: true)
data = data.to_h do |line|
  k, v = line.split(': ')
  vi = v.to_i
  # This is lazy but as none of the value in the file are `0` we can use the
  # failed converion to figure out if we have an operation or a leaf value
  next [k, v.to_i] unless vi == 0

  [k, v.split(' ')]
end

p part1(data)
p part2(data)
