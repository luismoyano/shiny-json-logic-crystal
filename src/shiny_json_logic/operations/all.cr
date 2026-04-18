module ShinyJsonLogic
  module Operations
    module All
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        collection = Iterables.iter_collection(args, scope_stack)
        filter = Iterables.iter_filter(args) || JSON::Any.new(nil)

        return JSON::Any.new(false) if collection.empty?

        collection.each do |item|
          scope_stack << item
          begin
            return JSON::Any.new(false) unless Truthy.call(Engine.call(filter, scope_stack))
          ensure
            scope_stack.pop
          end
        end
        JSON::Any.new(true)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("all") { |a, s| ShinyJsonLogic::Operations::All.call(a, s) }
