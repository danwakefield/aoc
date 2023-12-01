#!/usr/bin/env ruby


def part1(data)
  to_move_count = data.length
  len = data.length
  i = 0
  while to_move_count > 0
    v = data[i]
    pp [data.map(&:val), v.val]

    if v.nil?
      i = 0
      next
    end
    if v.moved
      i += 1
      next
    end

    if v.val == 0
      v.moved = true
      to_move_count -= 1
      next
    end

    v.moved = true
    new_index = i + v.val
    new_index -= 1 if v.val < 0
    if new_index >= len
      new_index = (new_index % (len - 1))
    elsif new_index <= 0
      new_index = len + new_index
    end

    data.delete_at(i)
    data.insert(new_index, v)
    to_move_count -= 1
  end
  pp [data.map(&:val), v.val]
  pp data.all?(&:moved)

  i_0 = data.index { |i| i.val == 0 }
  a = (i_0 + 1000) % len
  b = (i_0 + 2000) % len
  c = (i_0 + 3000) % len

  av = data[a].val
  bv = data[b].val
  cv = data[c].val

  [av, bv, cv].sum
end

def part2(data)
end


data = IO.readlines(ARGV[0], chomp: true)

Num = Struct.new(:val, :moved)

data = data.map { |l| Num.new(l.to_i, false) }

p part1(data)
p part2(data)
