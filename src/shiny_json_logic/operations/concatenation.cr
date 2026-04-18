module ShinyJsonLogic
  module Operations
    module Concatenation
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        result = String::Builder.new
        Base.wrap_nil(args).each do |op|
          evaluated = Engine.call(op, scope_stack)
          raw = evaluated.raw
          if raw.is_a?(Array(JSON::Any))
            raw.each { |item| result << Strings.any_to_s(item) }
          else
            result << Strings.any_to_s(evaluated)
          end
        end
        JSON::Any.new(result.to_s)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("cat") { |a, s| ShinyJsonLogic::Operations::Concatenation.call(a, s) }
