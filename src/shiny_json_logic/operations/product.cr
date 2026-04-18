module ShinyJsonLogic
  module Operations
    module Product
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        operands = Numerics.resolve_arith_args(args, scope_stack)
        return JSON::Any.new(1_i64) if operands.empty?

        result = 1.0
        operands.each do |op|
          result *= Numerics.numerify(op)
        end
        Numerics.numeric_result(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("*") { |a, s| ShinyJsonLogic::Operations::Product.call(a, s) }
