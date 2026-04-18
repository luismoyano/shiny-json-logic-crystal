require "./min_max"

module ShinyJsonLogic
  module Operations
    module Min
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        MinMax.resolve(args, scope_stack, :min)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("min") { |a, s| ShinyJsonLogic::Operations::Min.call(a, s) }
