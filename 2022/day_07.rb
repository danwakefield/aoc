#!/usr/bin/env ruby

Node = Struct.new(:name, :parent, :child_nodes, :child_files, :size, keyword_init: true) do
  def self.dir(name, parent)
    new(name: name, parent: parent, child_files: {}, child_nodes: {}, size: 0)
  end

  def add_node(name)
    return child_nodes[name] if child_nodes.key?(name)

    child_nodes[name] = Node.dir(name, self)
  end

  def add_file(name, size_string)
    size_to_add = child_files[name] = size_string.to_i
    add_size(size_to_add)
  end

  def add_size(size_to_add)
    self.size += size_to_add
    parent&.add_size(size_to_add)
  end
end

data = IO.readlines(ARGV[0], chomp: true)

# Returns arrarys, where the first item is the command, and the following
# items are the output. We skip the first line as we have to construct the
# root ourselves.
# In practice that is
# [
#   ['$ cd some_dir'],
#   ['$ ls', 'dir foo', '1234 filename']
# ]
cmds_and_output = data[1..].slice_when { |a, b| b.start_with?('$') }.to_a

root = node = Node.dir('/', nil)

cmds_and_output.each do |(cmd, *output)|
  if cmd.start_with?('$ cd')
    new_dir = cmd.split.last

    if new_dir == '..'
      node = node.parent || node
    else
      node = node.add_node(new_dir)
    end
  end

  if cmd.start_with?('$ ls')
    output.each do |entry|
      a, b = entry.split
      if a == 'dir'
        node.add_node(b)
      else
        node.add_file(b, a)
      end
    end
  end
end


pp root

def part1(tree)
  tree.child_nodes.each_pair.sum do |(_, node)|
    if node.size > 100000
      0 + part1(node)
    else
      node.size + part1(node)
    end
  end
end


def part2(tree)
  # How much space the device has
  total = 70_000_000
  # How much unused space it needs
  target = 30_000_000
  # whats leftover from the current tree
  unused = total - tree.size

  smallest_node_satisfying_deletion = tree

  dfs = ->(node) do
    node.child_nodes.each_pair do |(_, node)|
      deletion_gives_enough_space = (unused + node.size) > target
      smaller_than_current = smallest_node_satisfying_deletion.size > node.size

      if deletion_gives_enough_space && smaller_than_current
        smallest_node_satisfying_deletion = node
      end

      dfs.call(node)
    end
  end

  dfs.call(tree)

  smallest_node_satisfying_deletion.size
end

pp part1(root)
pp part2(root)
