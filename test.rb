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

=begin
Pulito.generate_ast('
foo = |l|
  print (join " " l).
  print "1 2 3".
  print 2.
  print 12.
.
x = ["a" "b" "c"].
foo x.
foo ["d" "e" "f"].
|1| .
')
=end

puts 'print "hi".'
Pulito.generate_ast('print "hi".')

puts
puts 'print 12.'
Pulito.generate_ast('print 12.')

puts
puts 'print -12.'
Pulito.generate_ast('print -12.')

puts "print 'a'."
Pulito.generate_ast("print 'a'.")

puts
puts 'foo = "bar".'
Pulito.generate_ast('foo = "bar".')

puts
puts 'foo = 12.'
Pulito.generate_ast('foo = 12.')

puts
puts 'foo = -12.'
Pulito.generate_ast('foo = -12.')

puts "foo = 'a'."
Pulito.generate_ast("foo = 'a'.")
