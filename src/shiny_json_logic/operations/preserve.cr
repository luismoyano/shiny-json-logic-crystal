module ShinyJsonLogic
  module Operations
    module Preserve
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        collection = Base.wrap(args)
        results = collection.map { |item| Engine.call(item, scope_stack) }
        results.size == 1 ? results.first : JSON::Any.new(results)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("preserve") { |a, s| ShinyJsonLogic::Operations::Preserve.call(a, s) }
