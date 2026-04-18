module ShinyJsonLogic
  module Operations
    module DoubleNot
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        operands = Base.wrap_nil(args)
        val = operands.size > 0 ? Engine.call(operands[0], scope_stack) : JSON::Any.new(nil)
        JSON::Any.new(Truthy.call(val))
      end
    end
  end
end

ShinyJsonLogic::Engine.register("!!") { |a, s| ShinyJsonLogic::Operations::DoubleNot.call(a, s) }
