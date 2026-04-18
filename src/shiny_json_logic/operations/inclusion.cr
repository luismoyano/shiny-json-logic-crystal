module ShinyJsonLogic
  module Operations
    module Inclusion
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raw = args.raw
        raise Errors::InvalidArguments.new unless raw.is_a?(Array(JSON::Any)) && raw.size >= 2

        needle = Engine.call(raw[0], scope_stack)
        haystack = Engine.call(raw[1], scope_stack)

        case haystack.raw
        when Array(JSON::Any)
          JSON::Any.new(haystack.as_a.any? { |el| el == needle })
        when String
          JSON::Any.new(haystack.as_s.includes?(needle.raw.to_s))
        else
          JSON::Any.new(false)
        end
      end
    end
  end
end

ShinyJsonLogic::Engine.register("in") { |a, s| ShinyJsonLogic::Operations::Inclusion.call(a, s) }
