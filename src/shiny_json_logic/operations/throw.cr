module ShinyJsonLogic
  module Operations
    module Throw
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raw_value = args.raw.is_a?(Array(JSON::Any)) ? args.as_a[0] : args

        error_type = if raw_value.raw.is_a?(Hash(String, JSON::Any)) && !raw_value.as_h.empty? &&
                         Engine::OPERATIONS.has_key?(raw_value.as_h.first_key)
          Engine.call(raw_value, scope_stack)
        else
          raw_value
        end

        raw_error_type = error_type.raw

        type_str = case raw_error_type
        when Hash(String, JSON::Any)
          raw_error_type["type"]?.try(&.raw.to_s)
        when Nil
          scope_stack.last.raw.as?(Hash(String, JSON::Any)).try { |h| h["type"]?.try(&.raw.to_s) }
        else
          raw_error_type.to_s
        end

        raise Errors::Base.new(type_str)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("throw") { |a, s| ShinyJsonLogic::Operations::Throw.call(a, s) }
