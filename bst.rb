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
      return Node.new(value) if current_node.nil?

      current_node.left = insert(value, current_node.left) if current_node.data > value
      current_node.right = insert(value, current_node.right) if current_node.data <= value

      current_node
    end

    def delete(value, current_node = root)
      return nil if current_node.nil?

      current_node.left = delete(value, current_node.left) if current_node.data > value
      current_node.right = delete(value, current_node.right) if current_node.data < value

      if current_node.data == value
        return current_node.right if current_node.left.nil?

        return current_node.left if current_node.right.nil?

        temp = find_minimum(current_node.right)
        current_node.right = delete(temp.data, current_node.right)
        current_node.data = temp.data
      end

      current_node
    end

    def find_minimum(current_node)
      return current_node if current_node.left.nil?

      find_minimum(current_node.left)
    end

    def find(value, current_node = root)
      return current_node if current_node.nil? || value == current_node.data

      return find(value, current_node.right) if value > current_node.data

      return find(value, current_node.left) if value < current_node.data
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
  end
end
