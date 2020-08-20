# frozen-string-literal: true

module BinarySearchTree
  # This class represents a node in the tree
  class Node
    include Comparable
    attr_accessor :data, :left, :right

    def <=>(other)
      data <=> other.data
    end

    def initialize(data, left, right)
      @data = data
      @left = left
      @right = right
    end
  end

  # This class represents the binary search tree
  class Tree
    attr_accessor :root

    def initialize(array); end

    def build_tree(array); end
  end
end
