#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'pulito.rb')

def test(type, *args)
  type = type.to_s
  type = eval "Pulito::#{type}"
  p type
  x = type.new(*args)
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

