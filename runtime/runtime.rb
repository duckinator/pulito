module Pulito
  class Runtime
    attr_accessor :top_level, :user_scope, :stack

    def initialize
      @top_level = Scope.new(self)
      @user_scope = Scope.new(@top_level)

      @stack = []

      Runtime.define_builtins(@top_level)
    end

    def eval(code)
      @user_scope.eval(code)
    end

    def self.define_builtins(scope)
      scope['true'] = true
      scope['false'] = false
      scope['nil'] = nil

      # This is the Ruby const_get function. Important for Ruby interop.
      scope.defspecial('::') do |scope, params|
        if name = params[1]
          context = Pulito.evaluate(params[0], scope)
        else
          name = params[0]
          context = Object
        end

        context.const_get(name.to_s)
      end

      # This is the Ruby 'send' function. Very important for Ruby
      # interop.
      #
      # (. obj (meth arg1 arg2))
      # (. obj meth arg1 arg2)
      # (.meth obj arg1 arg2)
      #
      # The last one will be translated to (. obj meth arg1 arg2)
      #
      scope.defspecial('.') do |scope, params|
        reciever = Pulito.evaluate(params[0], scope)

        case params[1]
        when Runtime::Identifier
          method = params[1].name
          args = params[2..-1]
        when Array
          raise "Method call expression is badly formed, expecting (. object (method ...))" if params[1].length == 0
          raise "Method name must be an identifier" unless params[1][0].is_a?(Runtime::Identifier)

          method = params[1][0].name
          args = params[1][1..-1]
        end
        
        block = nil

        if i = args.find_index{|arg| arg.to_s == '&' }
          block = Pulito.evaluate(args[i + 1], scope)
          args = args[0...i]
        end

        args.map!{|arg| Pulito.evaluate(arg, scope)}

        reciever.__send__(method, *args, &block)
      end

      scope.defspecial('quote') do |scope, params|
        params[0]
      end

      scope.defspecial('debug') do |scope, params|
        print "DEBUG: " if $DEBUG
        require 'pp'
        pp [scope, params] if $DEBUG
      end

      scope.defspecial('eval') do |scope, params|
        Pulito.evaluate(Pulito.evaluate(params[0], scope), scope)
      end

      scope.defspecial('do') do |scope, params|
        val = nil

        params.each do |param|
          val = Pulito.evaluate(param, scope)
        end

        val
      end

      scope.defspecial('if') do |scope, params|
        if(Pulito.evaluate(params[0], scope))
          Pulito.evaluate(params[1], scope)
        else
          Pulito.evaluate(params[2], scope) if params[2]
        end
      end

      scope.defspecial('while') do |scope, params|
        condition = params[0]
        body = params[1..-1]

        while(Pulito.evaluate(condition, scope))
          body.each do |form|
            Pulito.evaluate(form, scope)
          end
        end
      end

      scope.defspecial('or') do |scope, params|
        val = nil

        # return nil if there are no params
        if params.count > 0
          params.each do |param|
            if val = Pulito.evaluate(param, scope)
              # return if it evalutes to logical true
              break
            end
          end
        end

        val
      end

      scope.defspecial('and') do |scope, params|
        val = true

        # return true if there are no params
        if params.count > 0
          params.each do |param|
            if not val = Pulito.evaluate(param, scope)
              # return if it evalutes to logical false
              break
            end
          end
        end

        val
      end

      scope.defspecial('def') do |scope, params|
        scope[params[0]] = Pulito.evaluate(params[1], scope)
      end

      scope.defspecial('fn') do |scope, params|
        Function.new(scope, params[0], params[1..-1])
      end

      scope.defspecial('defn') do |scope, params|
        scope[params[0]] = Function.new(scope, params[1], params[2..-1])
      end

      scope.defspecial('macro') do |scope, params|
        Macro.new(scope, params[0], params[1..-1])
      end

      scope.defspecial('apply') do |scope, params|
        f = params[0]
        args = params[1..-1].map{|param| Pulito.evaluate(param, scope)}
        args += args.pop.to_a

        Pulito.evaluate([f, *args], scope)
      end

      scope.defspecial('macroexpand-1') do |scope, params|
        Pulito.macroexpand_1(Pulito.evaluate(params.first, scope), scope)
      end

      scope.defspecial('macroexpand') do |scope, params|
        Pulito.macroexpand(Pulito.evaluate(params.first, scope), scope)
      end

        # (def apply (fn (f & args)
        #   (. args (concat (. (. args (pop)) (to_a))))
        #   (eval (. [f] (+ args)))))

        # (def defn (macro (name args & forms)
        #   ['def name (apply fn args forms)]))

        # (defmacro import (& classes)
        #   (concat '(do)
        #           (map (fn (class)
        #                  ['def class [':: class]])
        #                classes)))

        # (defmacro loop (& body)
        #   ['. 'Kernel ['loop '& (concat ['fn ()] body)]])
      
      scope.eval(File.read(File.join(File.dirname(__FILE__), "core.pulito")))
    end
  end
end
