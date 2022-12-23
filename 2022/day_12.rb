#!/usr/bin/env ruby

require 'algorithms'
require 'set'

def reconstruct_path(from, to, parents)
  path = [to]
  x = parents[to]

  while x != from
    path << x
    x = parents[x]
  end

  path << from

  path.reverse
end

# See 2021/day_15 for A-Star details
def a_star(grid, from, to)
  x_max = grid.length
  y_max = grid.first.length

  heuristic_score = proc { |(x, y)| (x - to[0]).abs + (y - to[1]).abs }
  neighbour_cost = proc { |(x, y)| 1 }
  neighbours = proc do |(x, y)|
    current_char = grid[x][y]
    current_ord = grid[x][y].ord

    options = [
      [x+1, y], [x, y+1], [x-1, y], [x, y-1]
    ].reject { |(a, b)| a < 0 || b < 0 || a >= x_max || b >= y_max }

    if current_char == 'S'
      options.reject do |(a, b)|
        n = grid[a][b]
        n > 'b'
      end
    else
      options.reject do |(a, b)|
        n = grid[a][b]
        if n == 'E'
         current_char != 'z'
        else
          n.ord > current_ord + 1
        end
      end
    end
  end

  open_set = Set.new
  parents = {}

  costs = Hash.new(Float::INFINITY)
  costs[from] = 0
  open_set.add(from)

  heap = Containers::MinHeap.new
  heap.push(heuristic_score[from], from)

  while !open_set.empty?
    current = heap.pop
    open_set.delete(current)

    if current == to
      return reconstruct_path(from, to, parents)
    end

    neighbours[current].each do |n|
      new_cost = costs[current] + neighbour_cost[n]

      if new_cost < costs[n]
        parents[n] = current
        costs[n] = new_cost

        heap.push(new_cost + heuristic_score[n], n)
        open_set.add(n)
      end
    end
  end
end

def part1(grid)
  from = [0, 0]
  to = [0, 0]

  grid.each_with_index do |r, r_i|
    r.each_with_index do |v, c_i|
      from = [r_i, c_i] if v == 'S'
      to = [r_i, c_i] if v == 'E'
    end
  end

  a_star(grid, from, to)
end

def part2(grid)
  x_max = grid.length
  y_max = grid.first.length
  to = [0, 0]
  neighbours = proc do |(x, y)|
    current_char = grid[x][y]
    current_ord = grid[x][y].ord

    options = [
      [x+1, y], [x, y+1], [x-1, y], [x, y-1]
    ].reject { |(a, b)| a < 0 || b < 0 || a >= x_max || b >= y_max }

    if current_char == 'S'
      options.reject do |(a, b)|
        n = grid[a][b]
        n > 'b'
      end
    else
      options.reject do |(a, b)|
        n = grid[a][b]
        if n == 'E'
         current_char != 'z'
        else
          n.ord > current_ord + 1
        end
      end
    end
  end

  # complicated scan for candidates that can move. Looking at the grid its
  # just the first column thats eligible.
  froms = []
  grid.each_with_index do |r, r_i|
    r.each_with_index do |v, c_i|
      froms << [r_i, c_i] if v == 'a' && neighbours[[r_i, c_i]].any? { |(a, b)| grid[a][b] == 'b' }
      to = [r_i, c_i] if v == 'E'
    end
  end

  all_starts = froms.map { |from| a_star(grid, from, to).length - 3 }
  all_starts.sort.first
end


data = IO.readlines(ARGV[0], chomp: true).map(&:chars)

def draw(path, data)
  puts data.map(&:join).join("\n")
  path.each do |(x, y)|
    sleep 0.1
    data[x][y] = '.'
    puts data.map(&:join).join("\n")
  end
end

# I think I need to -3 because I-m counting both start and end when I
# shouldn't and then because of 0/1 indexing with `length`?
pp part1(data).length - 3
p part2(data)
