#!/usr/bin/env ruby

class String
  def valid_name?
    self.tr('[a-z][A-Z][0-9]_', '').empty?
  end

  def valid_name_start?
    self.tr('[a-z][A-Z]_', '').empty?
  end

  def alphanumeric?
    self.tr('[a-z][A-Z][0-9]', '').empty?
  end

  def numeric?
    self.tr('[0-9]', '').empty?
  end
end

module Pulito
  class Lexer
    def initialize(code = nil)
      lex code unless code.nil?
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
      error "Escaped #{escaped} outside of a #{type}." if @code[@i-1] == "\\"
    end

    def lex(code)
      @last_type = nil
      @code = code
      @line = 1
      @column = 1
      @i = 0
      while @i < @code.length
        char = @code[@i]
        @column += 1
        case char
          when '"'
            assertNotEscaped('double quote', 'string literal') unless @last_type == :string_literal
            @last_type = :string_literal
            assertHasMore("string literal")
            result = read_to('"')
            error "Unterminated string." if result.nil?
            puts "Found string: #{result.inspect}"

          when "'"
            @last_type = :char_literal
            assertNotEscaped('single quote', 'character literal')
            assertHasMore("character literal")
            result = read_to("'")
            error "Unterminated character literal." if result.nil?
            puts "Found string: #{result.inspect}"

          when "\n"
            @line += 1
            @column = 0

          else
            if char.valid_name_start?
              # Insert awesomeness
              old_i = @i
              @i += 1 while ![' ', "\n", "."].include? @code[@i]
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


l.lex('"\""')
#l.lex("\\\'")
#l.lex('"a')
#l.lex("'a")
