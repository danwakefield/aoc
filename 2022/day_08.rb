#!/usr/bin/env ruby

def part1(data)
  visibilty_map = {}

  data.each_with_index do |row, r|
    max_from_right = -1
    max_from_left = -1

    len = row.length - 1

    row.each_with_index do |v, c|
      if v > max_from_left
        max_from_left = v
        visibilty_map[[r,c]] = true
      end
    end

    row.reverse.each_with_index do |v, c|
      c = len - c
      if v > max_from_right
        max_from_right = v
        visibilty_map[[r,c]] = true
      end
    end
  end

  data.transpose.each_with_index do |col, c|
    max_from_top = -1
    max_from_bottom = -1

    len = col.length - 1

    col.each_with_index do |v, r|
      if v > max_from_top
        max_from_top = v
        visibilty_map[[r,c]] = true
      end
    end

    col.reverse.each_with_index do |v, r|
      r = len - r

      if v > max_from_bottom
        max_from_bottom = v
        visibilty_map[[r,c]] = true
      end
    end
  end

  visibilty_map.length
end

def part2(data)
  scenic_scores = {}

  cols = data.transpose
  len = data.length - 1
  # Can never be on the edge as that leads to multiplcation by 0

  data[1..-2].each.with_index(1) do |row, r|
    row[1..-2].each.with_index(1) do |v, c|
      view_left = view_right = view_up = view_down = 0

      # We walk in each direction, stopping at edges.
      # We alway count the tree but we then stop walking if its >= the current one
      cc = c - 1
      while cc >= 0
        view_left += 1
        break if row[cc] >= v
        cc -= 1
      end

      cc = c + 1
      while cc <= len
        view_right += 1
        break if row[cc] >= v
        cc += 1
      end

      rr = r - 1
      while rr >= 0
        view_up += 1
        break if cols[c][rr] >= v
        rr -= 1
      end

      rr = r + 1
      while rr <= len
        view_down += 1
        break if cols[c][rr] >= v
        rr += 1
      end

      scenic_scores[[r,c]] = view_up * view_down * view_left * view_right
    end
  end

  scenic_scores.max_by { |k, v| v }
end


data = IO.readlines(ARGV[0], chomp: true).map { |line| line.chars.map(&:to_i) }


pp part1(data)
pp part2(data)
