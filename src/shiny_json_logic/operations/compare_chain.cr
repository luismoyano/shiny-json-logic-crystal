module ShinyJsonLogic
  module Operations
    module CompareChain
      def self.comparable_type?(value : JSON::Any) : Bool
        raw = value.raw
        raw.is_a?(Float64) || raw.is_a?(Int64) || raw.is_a?(String) || raw.is_a?(Bool) || raw.nil?
      end

      def self.run(args : JSON::Any, scope_stack : Array(JSON::Any), &block : Float64 -> Bool) : JSON::Any
        operands = Base.wrap_nil(args)
        raise Errors::InvalidArguments.new if operands.size < 2

        prev = Engine.call(operands[0], scope_stack)
        raise Errors::NotANumber.new unless comparable_type?(prev)

        i = 1
        while i < operands.size
          curr = Engine.call(operands[i], scope_stack)
          raise Errors::NotANumber.new unless comparable_type?(curr)
          result = Numerics.compare(prev, curr)
          raise Errors::NotANumber.new if result.nil?
          return JSON::Any.new(false) unless block.call(result)
          prev = curr
          i += 1
        end
        JSON::Any.new(true)
      end
    end
  end
end
