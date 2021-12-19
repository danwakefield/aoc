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

# Taken from Wikipedia and turned into ruby
# // A* finds a path from start to goal.
# // h is the heuristic function. h(n) estimates the cost to reach goal from node n.
# function A_Star(start, goal, h)
#     // The set of discovered nodes that may need to be (re-)expanded.
#     // Initially, only the start node is known.
#     // This is usually implemented as a min-heap or priority queue rather than a hash-set.
#     openSet := {start}

#     // For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from start
#     // to n currently known.
#     cameFrom := an empty map

#     // For node n, gScore[n] is the cost of the cheapest path from start to n currently known.
#     gScore := map with default value of Infinity
#     gScore[start] := 0

#     // For node n, fScore[n] := gScore[n] + h(n). fScore[n] represents our current best guess as to
#     // how short a path from start to finish can be if it goes through n.
#     fScore := map with default value of Infinity
#     fScore[start] := h(start)

#     while openSet is not empty
#         // This operation can occur in O(1) time if openSet is a min-heap or a priority queue
#         current := the node in openSet having the lowest fScore[] value
#         if current = goal
#             return reconstruct_path(cameFrom, current)

#         openSet.Remove(current)
#         for each neighbor of current
#             // d(current,neighbor) is the weight of the edge from current to neighbor
#             // tentative_gScore is the distance from start to the neighbor through current
#             tentative_gScore := gScore[current] + d(current, neighbor)
#             if tentative_gScore < gScore[neighbor]
#                 // This path to neighbor is better than any previous one. Record it!
#                 cameFrom[neighbor] := current
#                 gScore[neighbor] := tentative_gScore
#                 fScore[neighbor] := tentative_gScore + h(neighbor)
#                 if neighbor not in openSet
#                     openSet.add(neighbor)

#     // Open set is empty but goal was never reached
#     return failure

def a_star(grid)
  x_max = grid.length
  y_max = grid.first.length

  from = [0, 0]
  to = [x_max - 1, y_max - 1]

  neighbours = proc do |(x, y)|
    [
      [x+1, y], [x, y+1], [x-1, y], [x, y-1]
    ].reject { |(a, b)| a < 0 || b < 0 || a >= x_max || b >= y_max }
  end

  heuristic_score = proc { |(x, y)| (x - to[0]).abs + (y - to[1]).abs }
  neighbour_cost = proc { |(x, y)| grid[x][y] }

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

  return nil
end

def part1(grid)
  path = a_star(grid)
  path_costs = path.map { |(x, y)| grid[x][y] }
  path_costs = path_costs[1, path_costs.length]

  path_costs.sum
end

def part2(grid)
  x_max = grid.length
  y_max = grid.first.length

  new_grid = Array.new(x_max * 5) { Array.new(y_max * 5) }

  5.times do |x|
    5.times do |y|
      x_max.times do |ox|
        y_max.times do |oy|
          new_x = ox + (x_max * x)
          new_y = oy + (y_max * y)

          new_val = grid[ox][oy] + x + y
          new_grid[new_x][new_y] = new_val % 9 == 0 ? 9 : new_val % 9
        end
      end
    end
  end

  path = a_star(new_grid)
  path_costs = path.map { |(x, y)| new_grid[x][y] }
  path_costs = path_costs[1, path_costs.length]

  path_costs.sum
end

data = IO.readlines(ARGV[0], chomp: true).map { |l| l.chars.map(&:to_i) }

puts "Part1: #{part1(data)}"
puts "Part2: #{part2(data)}"
