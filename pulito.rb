#!/usr/bin/env ruby

class String
  def alphanumeric?
    self.tr('[a-z][A-Z][0-9]', '').empty?
  end

  def numeric?
    self.tr('[0-9]', '').empty?
  end
end

module Pulito
  class Lexer
    def initialize(code = nil, in_statement = false)
      lex code unless code.nil?
      @in_statement = in_statement
    end
    def error(str)
      puts "[Lexer Error] #{@line}:#{@column}: #{str}"
      exit 1
    end

    def read_to(char)
      @i += 1
      old_i = @i
      res = @code.index(char, @i)
      if res.nil?
        return nil
      end
      @i = res
      @code[old_i...@i]
    end

    def expect(got, expected)
      error "Unexpected #{got.inspect}, expected #{expected.inspect}." if got != expected
    end

    def assertHasMore(type)
      if (@i+1) >= @code.length
        error "Unexpected end of file, expected #{type}."
        exit
      end
    end

    def assertNotEscaped(escaped, type)
      puts
      error "Escaped #{escaped} outside of a #{type}." if @code[@i-1] == "\\"
    end

    def lex(code)
      @code = code
      @line = 1
      @column = 1
      @i = 0
      while @i < @code.length
        char = @code[@i]
        @column += 1
        case char
          when '"'
            assertNotEscaped('double quote', 'string literal')
            assertHasMore("string literal")
            result = read_to('"')
            error "Unterminated string." if result.nil?
            puts "Found string: #{result.inspect}"

          when "'"
            assertNotEscaped('single quote', 'character literal')
            assertHasMore("character literal")
            result = read_to("'")
            expect "'", @code[@i]
            puts "Found string: #{result.inspect}"

          when "\n"
            @line += 1
            @column = 0

          else
            if char.alphanumeric?
              if !char.numeric? && !@in_statement
                # Start of a statement
              end
            end
        end
        @i += 1
      end
    end
  end
end

l = Pulito::Lexer.new
l.lex("foo = |x|
  print \"HAI\".
  print 'a'.
  print x.
.")


#l.lex("\\\"")
#l.lex("\\\'")
#l.lex('"a')
#l.lex("'a")