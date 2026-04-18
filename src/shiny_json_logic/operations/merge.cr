module ShinyJsonLogic
  module Operations
    module Merge
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        result = [] of JSON::Any
        operands = Base.wrap_nil(args)
        operands.each do |op|
          evaluated = Engine.call(op, scope_stack)
          raw = evaluated.raw
          if raw.is_a?(Array(JSON::Any))
            result.concat(raw)
          else
            result << evaluated
          end
        end
        JSON::Any.new(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("merge") { |a, s| ShinyJsonLogic::Operations::Merge.call(a, s) }
