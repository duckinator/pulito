#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'pulito.rb')

def type(type, *args)
  t = type.to_s
  t = eval "Pulito::#{type}"
  p t
  x = t.new(*args)
  puts x
  p x
  puts
  x
end

def ast(str)
  puts str
  Pulito.generate_ast(str)
  puts
end

