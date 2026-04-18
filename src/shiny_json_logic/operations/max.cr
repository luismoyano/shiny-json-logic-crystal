require "./min_max"

module ShinyJsonLogic
  module Operations
    module Max
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        MinMax.resolve(args, scope_stack, :max)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("max") { |a, s| ShinyJsonLogic::Operations::Max.call(a, s) }
