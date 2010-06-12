require 'rubygems'
require 'treetop'

Treetop.load 'pulito.treetop'

%w[runtime scope data/expression data/identifier callable/function callable/special callable/macro].each do |file|
  require File.join(File.dirname(__FILE__), 'runtime', file)
end

module Pulito
  def self.parse(string)
    @parser ||= PulitoParser.new
    @parser.parse(string)
  end

  def self.evaluate(expression, scope)
    case expression
    when Array
      p expression if $DEBUG
      return [] if expression.size == 0

      expression = Pulito.macroexpand(expression, scope)

      callable = Pulito.evaluate(expression.first, scope)
      raise "Tried to call '#{callable}', but it has no 'call' method." unless callable.respond_to? :call

      args = expression[1..-1]

      case callable
      when Runtime::Special
        callable.call(scope, args)
      when Runtime::Function
        callable.call(args.map{|arg| Pulito.evaluate(arg, scope)})
      else
        callable.call(*args)
      end
    when Runtime::Expression
      expression.eval(scope)
    else
      expression
    end
  end

  def self.macroexpand_1(form, scope)
    return form unless form.is_a?(Array)

    first = form.first

    val = scope[first] rescue nil
    if val.is_a? Runtime::Special
      form
    elsif val.is_a? Runtime::Macro
      val.call(form[1..-1])
    elsif first.is_a?(Runtime::Identifier) && first.name[0,1] == "."
      raise "Method call expression badly formed, expecting (.method object ...)" if form.length < 2

      [DOT, form[1], Pulito.sym(first.name[1..-1]), *form[2..-1]]
    else
      form
    end
  end

  def self.macroexpand(form, scope)
    exp = Pulito.macroexpand_1(form, scope)
    if exp == form
      form
    else
      Pulito.macroexpand(exp, scope)
    end
  end

  def self.sym(name)
    Runtime::Identifier.new(name)
  end

  def self.quote(form)
    [QUOTE, form]
  end

  def self.list(*args)
    [LIST, *args]
  end

  DOT              = self.sym(".")
  LIST             = self.sym("list")
  CONCAT           = self.sym("concat")
  QUOTE            = self.sym("quote")
  UNQUOTE          = self.sym("unquote")
  UNQUOTE_SPLICING = self.sym("unquote-splicing")

  class Program < Treetop::Runtime::SyntaxNode
    def eval(scope)
      convert!
      p @data if $DEBUG
      @data.map{|part| Pulito.evaluate(part, scope)}.last
    end

    def convert!
      @data ||= cells.map{|c| c.eval}
    end

    def cells
      elements
    end
  end

  class Cell < Treetop::Runtime::SyntaxNode
    def eval
      elements[1].eval
    end
  end

  class QuotedCell < Treetop::Runtime::SyntaxNode
    def eval
      Pulito.quote(elements[1].eval)
    end
  end

  class BackquotedCell < Treetop::Runtime::SyntaxNode
    def eval
      syntax_quote(elements[1].eval)
    end

    def syntax_quote(form)      
      if form.is_a? Runtime::Identifier
        Pulito.quote(form)
      elsif is_unquote?(form)
        form[1]
      elsif is_unquote_splicing?(form)
        raise "Splicing unquote (~@) was found outside a list."
      elsif form.is_a? Array
        [CONCAT, *expand_list(form)]
      else
        form
      end
    end

    def expand_list(list)
      list.map do |form|
        if is_unquote?(form)
          Pulito.list(form[1])
        elsif is_unquote_splicing?(form)
          form[1]
        else
          Pulito.list(syntax_quote(form)) 
        end
      end
    end

    def is_unquote?(form)
      form.is_a?(Array) && form.first == UNQUOTE
    end

    def is_unquote_splicing?(form)
      form.is_a?(Array) && form.first == UNQUOTE_SPLICING
    end
  end
  
  class UnquotedCell < Treetop::Runtime::SyntaxNode
    def eval
      [UNQUOTE, elements[1].eval]
    end
  end
  
  class UnquotedSplicingCell < Treetop::Runtime::SyntaxNode
    def eval
      [UNQUOTE_SPLICING, elements[1].eval]
    end
  end

  class Number < Treetop::Runtime::SyntaxNode
    def eval
      text_value.to_i
    end
  end

  class Symbol < Treetop::Runtime::SyntaxNode
    def eval
      Pulito.sym(text_value)
    end
  end

  class List < Treetop::Runtime::SyntaxNode
    def eval
      cells.map{|c| c.eval}
    end

    def cells
      elements[1].elements
    end
  end

  class Vector < Treetop::Runtime::SyntaxNode
    def eval
      Pulito.list(*cells.map{|c| c.eval})
    end

    def cells
      elements[1].elements
    end
  end

  class String < Treetop::Runtime::SyntaxNode
    def eval
      Kernel.eval(text_value)
    end
  end

  class Lambda < Treetop::Runtime::SyntaxNode
    def eval
      # What goes here? D:
    end
  end

  class Definition < Treetop::Runtime::SyntaxNode
    def eval
      # What goes here? D:
    end
  end
end

if $0 == __FILE__
  runtime = Pulito::Runtime.new
  tree = Pulito.parse(ARGF.read)
  value = tree.eval(runtime.user_scope)
end
