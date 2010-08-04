#!/usr/bin/env ruby

require 'pulito.rb'

puts "Pulito::Character"
c = Pulito::Character.new('a')
puts c
p c

puts "\nPulito::String"
s = Pulito::String.new("ab")
puts s
p s

puts "\nPulito::Number"
n = Pulito::Number.new(1)
puts n
p n

n2 = Pulito::Number.new(1.5)
puts n2
p n2

puts "\nPulito::Variable"
v = Pulito::Variable.new(:hai, n2)
puts v
p v

puts "\nPulito::List"
l = Pulito::List.new(["a", "b", 3, 4])
puts l
p l

puts "\nPulito::Lambda"
l = Pulito::Lambda.new(["a", "b", 3, 4], v)
puts l
p l

Pulito.generate_ast('
foo = |l|
  print (join " " l)
.
x = ["a" "b" "c"].
foo x.
foo ["d" "e" "f"].
')
