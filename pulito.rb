require File.join(File.dirname(__FILE__), 'datatypes.rb')

module Pulito
  def self.parse(string)
    string.gsub!("\n", "\n         ")
    puts "Parsing: #{string}"
  end
end
