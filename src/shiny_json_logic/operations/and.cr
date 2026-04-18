module ShinyJsonLogic
  module Operations
    module And
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raise Errors::InvalidArguments.new unless args.raw.is_a?(Array(JSON::Any))
        items = args.as_a
        return JSON::Any.new(false) if items.empty?

        result = JSON::Any.new(nil)
        items.each do |item|
          result = Engine.call(item, scope_stack)
          return result unless Truthy.call(result)
        end
        result
      end
    end
  end
end

ShinyJsonLogic::Engine.register("and") { |a, s| ShinyJsonLogic::Operations::And.call(a, s) }
