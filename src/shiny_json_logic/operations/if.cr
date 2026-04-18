module ShinyJsonLogic
  module Operations
    module If
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raise Errors::InvalidArguments.new unless args.raw.is_a?(Array(JSON::Any))
        rules = args.as_a

        i = 0
        n = rules.size
        while i < n
          condition_rule = rules[i]
          value_rule = i + 1 < n ? rules[i + 1] : nil

          condition_result = Engine.call(condition_rule, scope_stack)
          return condition_result if value_rule.nil?

          return Engine.call(value_rule, scope_stack) if Truthy.call(condition_result)

          i += 2
        end

        JSON::Any.new(nil)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("if")  { |a, s| ShinyJsonLogic::Operations::If.call(a, s) }
ShinyJsonLogic::Engine.register("?:")  { |a, s| ShinyJsonLogic::Operations::If.call(a, s) }
