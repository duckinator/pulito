module Pulito
  class Base
    attr_accessor :data
    def initialize(data)
      if self.class.instance_methods.include?(:set)
        set(data) # Run new classes set() method
      else
        @data = data # Default value for @data
      end
    end

    def ==(other)
      if self.class == other.class
        @data == other.data
      else
        false
      end
    end

    def to_s
      @data.to_s
    end

    def inspect
      to_s
    end # def inspect
  end   # class Base

  class Character < Base
    def set(data)
      if data.length > 1
        raise TypeError, "String \"#{data}\" given when Character expected!"
      end
      @data = data.to_s
    end

    def inspect
      "'" + @data + "'"
    end # def inspect
  end   # class Character < Base

  class String < Base
    def set(data)
      @data = data.to_s
    end

    def [](i)
      Character.new(@data[i])
    end

    def inspect
      '"' + @data + '"'
    end
  end

  class Number < Base
    def set(data)
      @data = data.to_f
    end

    def to_s
      if @data.to_i.to_f == @data
        # Treat it as an integer, if the decimal is .0
        @data.to_i.to_s
      else
        # Otherwise, treat it as a float
        @data.to_s
      end
    end
  end

  class List < Base
    def set(data)
      if !data.is_a?(Array)
        raise TypeError, "#{data.class} \"#{data}\" given when List expected!"
      end
      @data = data
    end

    def [](i)
      @data[i]
    end

    def []=(i, value)
      @data[i] = value
    end

    def to_s
      tmp = @data.map(&:inspect)
      "[#{tmp.join(' ')}]"
    end
  end

  class Variable < Base
    attr_accessor :name, :value
    def initialize(name, value)
      set(name, value)
    end

    def set(name, value)
      @name = name.to_sym
      @value = value
    end

    def ==(other)
      if self.class == other.class
        @value == other.value
      else
        false
      end
    end

    def to_s
      @value.to_s
    end

    def inspect
      @value.inspect
    end
  end

  class Lambda < Base
    attr_accessor :args, :body
    def initialize(args, body)
      @args = args
      @body = Pulito.generate_ast(body)
    end

    def to_s
      @body.to_s
    end
  end
end
