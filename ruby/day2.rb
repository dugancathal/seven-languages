#!/usr/bin/env ruby

require_relative 'support'

section_header('Treeeeeees!')


class Tree
  attr_accessor :children, :node_name

  def initialize(node_name, children=[])
    @children = children
    @node_name = node_name
  end

  def visit_all(&block)
    visit &block
    children.each {|child| child.visit_all &block}
  end

  def visit(&block)
    block.call self
  end
end

tree = Tree.new("Ruby", [Tree.new("Reia"), Tree.new("MacRuby")])
puts "visiting a node"
tree.visit {|node| puts node.node_name}
puts

puts "visiting the whole tree"
tree.visit_all {|node| puts node.node_name}

section_header('ToFile')

module ToFile
  def filename
    "object_#{self.object_id}.txt"
  end

  def to_f
    File.write(filename, to_s)
  end
end

class Person
  include ToFile
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def to_s
    name
  end
end

Person.new('TJ Taylor').to_f



### Exercises
section_header('Enumerable')

# Print an array, four numbers at a time, just using each
puts 'Using only #each'
arr = (1..16).to_a

collection = []
arr.each do |num|
  collection << num
  if collection.length == 4
    puts collection, '---'
    collection = []
  end
end

# Now use #each_slice
puts 'Now using #each_slice'
arr.each_slice(4) {|slice| puts slice, '---' }

section_header('Tree redux')
# Make Tree#initialize accept a nested hash and return Tree(s)
class Tree
  def initialize(nested)
    @node_name, kids = nested.first
    @children = kids.map {|child, rest| Tree.new(child => rest) }
  end
end
tree = Tree.new({'grandpa' => { 'dad' => {'child 1' => {}, 'child 2' => {} }, 'uncle' => {'child 3' => {}, 'child 4' => {} } } })
tree.visit_all {|node| puts node.node_name }


section_header('rgrep - Slowest grepper EVAR')
File.readlines(__FILE__).each_with_index {|line, i| puts "#{i}: #{line}" if line =~ /tree/i}
