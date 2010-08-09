#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'test.rb')

ast 'print "hi".'

ast 'print 12.'

ast 'print -12.'

ast "print 'a'."

ast 'foo = "bar".'

ast 'foo = 12.'

ast 'foo = -12.'

ast "foo = 'a'."

