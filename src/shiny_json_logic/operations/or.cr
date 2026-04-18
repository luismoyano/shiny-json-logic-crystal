module ShinyJsonLogic
  module Operations
    module Or
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raise Errors::InvalidArguments.new unless args.raw.is_a?(Array(JSON::Any))
        items = args.as_a
        return JSON::Any.new(false) if items.empty?

        result = JSON::Any.new(nil)
        items.each do |item|
          result = Engine.call(item, scope_stack)
          return result if Truthy.call(result)
        end
        result
      end
    end
  end
end

ShinyJsonLogic::Engine.register("or") { |a, s| ShinyJsonLogic::Operations::Or.call(a, s) }
