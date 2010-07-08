require File.join(File.dirname(__FILE__), 'datatypes.rb')

module Pulito
  def self.generate_ast(item)
    string = item.to_s
    string.gsub!("\n", "\n         ")
    puts "Parsing: #{string}"
  end
end
