#!/usr/bin/env ruby

files = Dir[File.join(File.dirname(__FILE__), '*')]
%w{all test}.each do |x|
  files.delete(File.join(File.dirname(__FILE__), "#{x}.rb"))
end

files.each do |file|
  print "#{file}:\n\n"
  require file
  puts "\n"
end
