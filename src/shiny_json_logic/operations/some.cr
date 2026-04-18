module ShinyJsonLogic
  module Operations
    module Some
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        collection = Iterables.iter_collection(args, scope_stack)
        filter = Iterables.iter_filter(args) || JSON::Any.new(nil)

        collection.each do |item|
          scope_stack << item
          begin
            return JSON::Any.new(true) if Truthy.call(Engine.call(filter, scope_stack))
          ensure
            scope_stack.pop
          end
        end
        JSON::Any.new(false)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("some") { |a, s| ShinyJsonLogic::Operations::Some.call(a, s) }
