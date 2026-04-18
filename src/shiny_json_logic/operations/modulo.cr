module ShinyJsonLogic
  module Operations
    module Modulo
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        operands = Numerics.resolve_arith_args(args, scope_stack)
        raise Errors::InvalidArguments.new if operands.size < 2

        result = Numerics.numerify(operands[0])
        i = 1
        while i < operands.size
          b = Numerics.numerify(operands[i])
          raise Errors::NotANumber.new if b == 0.0
          result = result.remainder(b)
          i += 1
        end
        Numerics.numeric_result(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("%") { |a, s| ShinyJsonLogic::Operations::Modulo.call(a, s) }
