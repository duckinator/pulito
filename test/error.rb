#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'test.rb')

ast '
foo = |1|
  print (join " " l).
  print "1 2 3".
  print 2.
  print 12.
.
'
