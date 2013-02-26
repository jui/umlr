#!/usr/bin/env ruby

require 'diagram_graph.rb'

module Umlr

  class Node
    attr_accessor :properties
    def initialize(type, name, &block)
      @type = type || ""
      @name = name || ""
      @properties = Array.new
      instance_eval(&block)
    end

    def property(name, type = "")
      @properties.push("#{name}: #{type}")
    end

    def to_diagram
      return [@type.to_s, @name.to_s, @properties]
    end
  end
  
  @@diagram = DiagramGraph.new

  def self.add(type, name, &block)
    node = Node.new(type, name, &block)
    @@diagram.add_node(node.to_diagram)
  end

  def self.add_edge(type, opts)
    if opts.is_a? Hash
      from = opts.keys.first
      to = opts[from]
    end
    label = ""
    @@diagram.add_edge([type, from, to, label])
  end

  def self.generate
    @@diagram.to_dot
  end

  def self.generate_png(filename)
    IO.popen("dot -Tpng -o #{filename}","r+") do |f|
      f.puts self.generate
    end
  end
	
end

def model(name, &block)
  Umlr::add(:model, name, &block)
end

def many_to_many(opts)
  Umlr::add_edge("many-many",opts)
end

def one_to_many(opts)
  Umlr::add_edge("one-many",opts)
end

def one_to_one(opts)
  Umlr::add_edge("one-one",opts)
end

