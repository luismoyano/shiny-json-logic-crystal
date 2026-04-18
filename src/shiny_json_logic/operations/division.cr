module ShinyJsonLogic
  module Operations
    module Division
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        operands = Numerics.resolve_arith_args(args, scope_stack)
        raise Errors::InvalidArguments.new if operands.empty?

        result = Numerics.numerify(operands[0])
        return Numerics.numeric_result(1.0 / result) if operands.size == 1

        i = 1
        while i < operands.size
          divisor = Numerics.numerify(operands[i])
          raise Errors::NotANumber.new if divisor == 0.0
          result /= divisor
          i += 1
        end
        Numerics.numeric_result(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("/") { |a, s| ShinyJsonLogic::Operations::Division.call(a, s) }
