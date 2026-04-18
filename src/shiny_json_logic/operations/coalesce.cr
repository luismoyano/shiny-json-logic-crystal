module ShinyJsonLogic
  module Operations
    module Coalesce
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        items = Base.wrap_nil(args)
        items.each do |item|
          result = Engine.call(item, scope_stack)
          return result unless result.raw.nil?
        end
        JSON::Any.new(nil)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("??") { |a, s| ShinyJsonLogic::Operations::Coalesce.call(a, s) }
