#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'test.rb')

ast '
foo = |l|
  print (join " " l).
  print "1 2 3".
  print 2.
  print 12.
.
x = ["a" "b" "c"].
foo x.
foo ["d" "e" "f"].
'
