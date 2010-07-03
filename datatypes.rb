module Pulito
  class Base
    attr_accessor :data
    def initialize(data)
      @parent_type ||= nil
      if (@parent_type != nil) && (data.class != Pulito.const_get(@parent_type.capitalize))
        raise TypeError, "expected Pulito::#{@parent_type.capitalize}, got #{data.class}"
      end
      @data = data # Default value for @data
    end

    def ==(other)
      if self.class == other.class
        @data == other.data
      else
        false
      end
    end # def ==(other)
  end   # class Base

  class Character < Base
    def initialize(data)
      super(data)
      if @data.length > 1
        raise TypeError, "string given when character expected"
      end
    end

    def to_s
      @data.to_s
    end

    def inspect
      "#<#{self.class} data=#{@data.inspect}>"
    end # def inspect
  end   # class Character < Base

  class Number < Base
    def initialize(data)
      super(data)
      @data = data.to_f
    end
  end
end

c = Pulito::Character.new('aa')
puts c
p c
