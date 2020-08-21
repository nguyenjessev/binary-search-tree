# frozen-string-literal: true

require 'pry'

module BinarySearchTree
  # This class represents a node in the tree
  class Node
    include Comparable
    attr_accessor :data, :left, :right

    def <=>(other)
      data <=> other.data
    end

    def initialize(data, left = nil, right = nil)
      @data = data
      @left = left
      @right = right
    end
  end

  # This class represents the binary search tree
  class Tree
    attr_accessor :root

    def initialize(array)
      @root = build_tree(array)
    end

    def build_tree(array)
      return nil if array.empty?

      nodes = array.uniq.sort
      middle = (nodes.length - 1) / 2
      left_nodes = middle.positive? ? nodes[0..(middle - 1)] : []
      right_nodes = nodes[(middle + 1)..-1]

      middle_node = Node.new(nodes[middle], build_tree(left_nodes), build_tree(right_nodes))

      middle_node
    end

    def insert(value, current_node = root)
      if current_node.data > value
        if current_node.left.nil?
          current_node.left = Node.new(value)
        else
          insert(value, current_node.left)
        end
      elsif current_node.right.nil?
        current_node.right = Node.new(value)
      else
        insert(value, current_node.right)
      end
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
  end
end

test = Array.new(15) { rand(1..100) }
test_tree = BinarySearchTree::Tree.new(test)
puts
p test.uniq.sort
puts
test_tree.pretty_print
