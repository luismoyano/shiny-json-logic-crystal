module ShinyJsonLogic
  module Operations
    module Filter
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raw = args.raw
        raise Errors::InvalidArguments.new unless raw.is_a?(Array(JSON::Any)) && raw.size >= 2
        filter = raw[1]
        collection = Iterables.iter_collection(args, scope_stack)

        result = [] of JSON::Any
        collection.each do |item|
          scope_stack << item
          begin
            result << item if Truthy.call(Engine.call(filter, scope_stack))
          ensure
            scope_stack.pop
          end
        end
        JSON::Any.new(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("filter") { |a, s| ShinyJsonLogic::Operations::Filter.call(a, s) }
