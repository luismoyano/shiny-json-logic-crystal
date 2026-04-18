module ShinyJsonLogic
  module Operations
    module Equal
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        CompareChain.run(args, scope_stack) { |r| r == 0.0 }
      end
    end
  end
end

ShinyJsonLogic::Engine.register("==") { |a, s| ShinyJsonLogic::Operations::Equal.call(a, s) }
