module ShinyJsonLogic
  module Operations
    module Addition
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        operands = Numerics.resolve_arith_args(args, scope_stack)
        result = 0.0
        operands.each do |op|
          result += Numerics.numerify(op)
        end
        Numerics.numeric_result(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("+") { |a, s| ShinyJsonLogic::Operations::Addition.call(a, s) }
