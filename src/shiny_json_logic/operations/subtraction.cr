module ShinyJsonLogic
  module Operations
    module Subtraction
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        operands = Numerics.resolve_arith_args(args, scope_stack)
        raise Errors::InvalidArguments.new if operands.empty?

        result = Numerics.numerify(operands[0])
        return Numerics.numeric_result(-result) if operands.size == 1

        i = 1
        while i < operands.size
          result -= Numerics.numerify(operands[i])
          i += 1
        end
        Numerics.numeric_result(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("-") { |a, s| ShinyJsonLogic::Operations::Subtraction.call(a, s) }
