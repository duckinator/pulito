require File.join(File.dirname(__FILE__), 'datatypes.rb')

module Pulito
  def self.generate_ast(arg)
    Parser.new.generate_ast(arg)
  end

  class Parser
    def start(type, offset=0)
      @offset = offset
      @finished = false
      @starti = @i + offset
      @startline = @line
      @startpos = @linepos + offset
      @type = type
      @item = ''
      save
    end

    def finish
      @finished = false
    end

    def save
      if @offset == 0
        @item += @arg[@i]
      elsif @offset < 0
        @offset = 0
      else
        @offset -= 1
      end
    end

    def error(message)
      puts "#{@line}:#{@linepos}: #{message}"
      exit 1
    end

    def check(type)
      if type.to_s != @type.to_s
        puts "#{@line}:#{@linepos}: Changed from #{@type.nil? ? "<unknown>" : @type.to_s} to #{type}. Last item (#{@startline}:#{@startpos}-#{@line}:#{@linepos}): '#{@item}'"
      end
    end

    def generate_ast(arg)
      if arg.is_a?(::String)
        @line = 1
        @linepos = 1
        @startline = 1
        @startpos = 1
        @starti = 1
        @type = nil
        @item = ''
        @finished = false
        @offset = 0

        arg.gsub!("\r\n", "\n")
        arg.gsub!("\r", "\n") # We can assume there's no \r\n, so this is safe
        @arg = arg
        @lines = arg.split("\n")

        arg.length.times do |i|
          current = arg[i]
          @linepos += 1
          @i = i
          if @finished
            start :nil, i
          end

          case current
            when '|'  # Arglists
              check :arglist
              if @type == :arglist
                finish
              else
                start :arglist
              end

            when "'" # Chars
              check :char
              if @type == :char
                finish
              else
                start :char, 1
              end

            when '"' # Strings
              check :string
              if @type == :string
                finish
              else
                start :string, 1
              end

            when '1'..'9' # Numbers
              check :number
              if @type == :arglist
                error "Unexpected number in argument list."
              else
                if @type == :number
                  @item += current
                elsif !@type.nil?
                  start :number
                else
                  puts 'number in middle of something else'
                end
              end

            when '.'
              puts "#{@line}:#{i}: End of #{@type} started at #{@startline}:#{@startpos}: '#{@item}'"
              start :nil, 1

            when ' ' || "\t"
              check :whitespace
              if @type == :whitespace
                @item += current
              else
                start :whitespace
              end

            when "\n"
              @line += 1
              @linepos = 0
              puts "line #{@line}"

            else
              if (@type == :string) || (@type == :char)
                @item += current
              elsif (current == '-') && ('1'..'9').include?(arg[i+1])
                if @type != :number
                  start :number
                end
              else
                if @type == :unknown
                  @item += current
                else
                  start :unknown
                end
              end
          end
          #puts "@item: '#{@item}'"
        end
      else
        puts "#{arg.class} in generate_ast"
      end
    end
  end
end
