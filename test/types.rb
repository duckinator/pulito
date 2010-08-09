#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'test.rb')

c = type :Character, 'a'

s = type :String, "ab"

n = type :Number, 1

n2 = type :Number, 1.5

v = type :Variable, :hai, n2

li = type :List, ["a", "b", 3, 4]

la = type :Lambda, ["a", "b", 3, 4], v

