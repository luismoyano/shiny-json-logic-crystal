module ShinyJsonLogic
  module Operations
    module Map
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raw = args.raw
        raise Errors::InvalidArguments.new unless raw.is_a?(Array(JSON::Any)) && raw.size >= 2
        filter = raw[1]
        collection = Iterables.iter_collection(args, scope_stack)

        result = collection.map do |item|
          scope_stack << item
          begin
            Engine.call(filter, scope_stack)
          ensure
            scope_stack.pop
          end
        end
        JSON::Any.new(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("map") { |a, s| ShinyJsonLogic::Operations::Map.call(a, s) }
