#!/usr/bin/env ruby

require 'json'

class Node < Struct.new(:parent, :left, :right, :direction_from_parent)
  def self.from_array(a, parent = nil, direction_from_parent = nil)
    l = a[0]
    r = a[1]

    n = Node.new(parent, nil, nil, direction_from_parent)

    n.left = l.is_a?(Array) ? Node.from_array(l, n, :left) : l
    n.right = r.is_a?(Array) ? Node.from_array(r, n, :right) : r

    n
  end

  def magnitude
    l = left.is_a?(Node) ? left.magnitude : left
    r = right.is_a?(Node) ? right.magnitude : right

    (3 * l) + (2 * r)
  end

  # Add's two root nodes together
  def +(other)
    new_root = Node.new(nil, nil, nil)

    self.parent = new_root
    self.direction_from_parent = :left
    other.parent = new_root
    other.direction_from_parent = :right

    new_root.left = self
    new_root.right = other

    new_root.reduce

    new_root
  end

  # We look for the leftmost value that is 4 deep
  def find_depth(d = 4)
    return self if d == 0

    l = self.left.find_depth(d-1) if self.left.is_a?(Node)
    return l unless l.nil?

    r = self.right.find_depth(d-1) if self.right.is_a?(Node)
    return r unless r.nil?

    nil
  end

  def find_value_gte(v = 10)
    if self.left.is_a?(Integer)
      if self.left >= 10
        return { node: self, direction: :left }
      end
    else
      n = self.left.find_value_gte(v)
      return n if n
    end

    if self.right.is_a?(Integer)
      if self.right >= 10
        return { node: self, direction: :right }
      end
    else
      n = self.right.find_value_gte(v)
      return n if n
    end

    nil
  end

  #           1
  #          / \
  #         /   \
  #        2      3
  #       / \    / \
  #      4   5  /   \
  #            9     8
  #           / \   / \
  #          y   x 6   7
  #
  # Nodes are leaf nodes if the r/l values are not themselves Nodes.
  # To find the first value we walk up and look for the first node that is the
  # opposite direction to what we are searching.
  # e.g Node is `8` in the above.
  # We search up by parents until we find a node that is to the right of its
  # parent. In this case, `8` is the right child, that means we use `3` (its
  # parent) as the candidate.
  #
  # In the case above we want to return [Node(9), :right] when searching left from `6`
  # If `9` was a concrete value we would have returned [Node(3), :left]
  #
  # Returning the node gives us access to the tree at the point replacements
  # need to happen.

  def find_left
    candidate = nil

    current = self
    parent = current.parent

    while parent != nil
      if current.direction_from_parent == :right
        candidate = parent
        break
      end

      current = parent
      parent = current.parent
    end

    if candidate
      return { node: candidate, direction: :left } unless candidate.left.is_a?(Node)

      candidate = candidate.left
      while candidate.right.is_a?(Node)
        candidate = candidate.right
      end

      return { node: candidate, direction: :right }
    end

    nil
  end

  def find_right
    candidate = nil

    current = self
    parent = current.parent

    while parent != nil
      if current.direction_from_parent == :left
        candidate = parent
        break
      end

      current = parent
      parent = current.parent
    end

    if candidate
      return { node: candidate, direction: :right } unless candidate.right.is_a?(Node)

      candidate = candidate.right
      while candidate.left.is_a?(Node)
        candidate = candidate.left
      end

      return { node: candidate, direction: :left }
    end

    nil
  end

  # Support 4 different assignment types
  # |                  | direction is Node | direction is Integer |
  # |------------------|-------------------|----------------------|
  # | value is Node    | Replace (=)       | Replace (=)          |
  # | value is Integer | Replace (=)       | Add (+=)             |
  def assign_direction(direction, value)
    case direction
    when :right
      if self.right.is_a?(Node) || value.is_a?(Node)
        self.right = value
      else
        self.right += value
      end
    when :left
      if self.left.is_a?(Node) || value.is_a?(Node)
        self.left = value
      else
        self.left += value
      end
    end
  end

  def reduce
    did_explode = true
    did_split = true
    while did_explode || did_split
      while did_explode
        did_explode = explode
      end

      did_split = split
      did_explode = explode
    end
  end

  def explode
    # We know that anything at depth 4 has 2 concrete values since we
    # always overflow them when they reach this depth
    n = self.find_depth(4)
    return false if n.nil?

    r = n.find_right
    l = n.find_left

    r[:node].assign_direction(r[:direction], n.right) if r
    l[:node].assign_direction(l[:direction], n.left) if l

    # Replace Node (self) with `0` value
    n.parent.assign_direction(n.direction_from_parent, 0)

    true
  end

  def split
    n = self.find_value_gte(10)

    return false if n.nil?

    v = n[:node].send(n[:direction])

    l = (v/2.0).floor
    r = (v/2.0).ceil

    new_node = Node.new(n[:node], l, r, n[:direction])

    n[:node].assign_direction(n[:direction], new_node)

    true
  end

  def to_a
    [
      self.left.is_a?(Node) ? self.left.to_a : self.left,
      self.right.is_a?(Node) ? self.right.to_a : self.right,
    ]
  end
end

def part1(data)
  data = data.map { |d| Node.from_array(d) }

  sum = data[0]

  data[1,999].each do |d|
    sum = sum + d
  end

  sum.magnitude
end

def part2(data)
  max_magnitude = 0

  # We recreate the trees after each addition so we dont have weird data since
  # we modify they during the addition
  data.combination(2).each do |(a, b)|
    a_tree_1 = Node.from_array(a)
    b_tree_1 = Node.from_array(b)

    magnitude = (a_tree_1 + b_tree_1).magnitude
    if magnitude > max_magnitude
      max_magnitude = magnitude
    end

    a_tree_2 = Node.from_array(a)
    b_tree_2 = Node.from_array(b)

    magnitude = (b_tree_2 + a_tree_2).magnitude
    if magnitude > max_magnitude
      max_magnitude = magnitude
    end
  end

  max_magnitude
end

data = IO.readlines(ARGV[0], chomp: true).map { |l| JSON.parse(l) }

puts "Part1: #{part1(data)}"
puts "Part2: #{part2(data)}"
