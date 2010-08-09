#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'test.rb')

c = test :Character, 'a'

s = test :String, "ab"

n = test :Number, 1

n2 = test :Number, 1.5

v = test :Variable, :hai, n2

li = test :List, ["a", "b", 3, 4]

la = test :Lambda, ["a", "b", 3, 4], v

