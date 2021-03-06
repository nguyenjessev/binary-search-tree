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

    def level_order(current_node = root)
      return [] if current_node.nil?

      queue = [current_node]
      result = []

      until queue.empty?
        working_node = queue.shift
        queue << working_node.left unless working_node.left.nil?
        queue << working_node.right unless working_node.right.nil?
        result << working_node.data
      end

      result
    end

    def inorder(current_node = root)
      return [] if current_node.nil?

      result = []

      result.concat(inorder(current_node.left)) unless current_node.left.nil?
      result << current_node.data
      result.concat(inorder(current_node.right)) unless current_node.right.nil?

      result
    end

    def preorder(current_node = root)
      return [] if current_node.nil?

      result = []

      result << current_node.data
      result.concat(preorder(current_node.left)) unless current_node.left.nil?
      result.concat(preorder(current_node.right)) unless current_node.right.nil?

      result
    end

    def postorder(current_node = root)
      return [] if current_node.nil?

      result = []

      result.concat(postorder(current_node.left)) unless current_node.left.nil?
      result.concat(postorder(current_node.right)) unless current_node.right.nil?
      result << current_node.data

      result
    end

    def height(current_node)
      return -1 if current_node.nil?

      [height(current_node.left), height(current_node.right)].max + 1
    end

    def depth(target, current_node = root)
      return nil if current_node.nil? || target.nil?

      return 0 if current_node == target

      left_depth = depth(target, current_node.left)
      return left_depth + 1 unless left_depth.nil?

      right_depth = depth(target, current_node.right)
      return right_depth + 1 unless right_depth.nil?

      nil
    end

    def balanced?(current_node = root)
      return true if current_node.nil?

      left_height = height(current_node.left)
      right_height = height(current_node.right)

      return true if balanced?(current_node.left) && balanced?(current_node.right) &&
                     (left_height - right_height).abs <= 1

      false
    end

    def rebalance
      self.root = build_tree(inorder)
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
      pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
      puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
      pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end
  end
end

test = Array.new(15) { rand(1..100) }
tree = BinarySearchTree::Tree.new(test)
puts "Balanced?: #{tree.balanced?}"
puts "Level order: #{tree.level_order.join(', ')}"
puts "Preorder: #{tree.preorder.join(', ')}"
puts "Postorder: #{tree.postorder.join(', ')}"
puts "Inorder: #{tree.inorder.join(', ')}"
10.times do
  tree.insert(rand(100..200))
end
puts "Balanced?: #{tree.balanced?}"
tree.rebalance
puts "Balanced?: #{tree.balanced?}"
puts "Level order: #{tree.level_order.join(', ')}"
puts "Preorder: #{tree.preorder.join(', ')}"
puts "Postorder: #{tree.postorder.join(', ')}"
puts "Inorder: #{tree.inorder.join(', ')}"
