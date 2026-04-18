module ShinyJsonLogic
  module Operations
    module StrictDifferent
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        operands = Base.wrap_nil(args)
        raise Errors::InvalidArguments.new if operands.size < 2
        prev = Numerics.strict_cast(Engine.call(operands[0], scope_stack))
        i = 1
        while i < operands.size
          curr = Numerics.strict_cast(Engine.call(operands[i], scope_stack))
          return JSON::Any.new(false) unless curr != prev
          prev = curr
          i += 1
        end
        JSON::Any.new(true)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("!==") { |a, s| ShinyJsonLogic::Operations::StrictDifferent.call(a, s) }
