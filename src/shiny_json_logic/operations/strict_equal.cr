module ShinyJsonLogic
  module Operations
    module StrictEqual
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        operands = Base.wrap_nil(args)
        raise Errors::InvalidArguments.new if operands.size < 2
        first = Numerics.strict_cast(Engine.call(operands[0], scope_stack))
        i = 1
        while i < operands.size
          return JSON::Any.new(false) unless Numerics.strict_cast(Engine.call(operands[i], scope_stack)) == first
          i += 1
        end
        JSON::Any.new(true)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("===") { |a, s| ShinyJsonLogic::Operations::StrictEqual.call(a, s) }
