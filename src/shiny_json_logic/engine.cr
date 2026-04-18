module ShinyJsonLogic
  module Engine
    OPERATIONS = {} of String => Proc(JSON::Any, Array(JSON::Any), JSON::Any)

    def self.register(op : String, &block : JSON::Any, Array(JSON::Any) -> JSON::Any)
      OPERATIONS[op] = block
    end

    def self.call(rule : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
      raw = rule.raw
      case raw
      when Hash(String, JSON::Any)
        return rule if raw.empty?
        raise Errors::UnknownOperator.new if raw.size > 1

        op_key = raw.first_key
        args   = raw.first_value

        handler = OPERATIONS[op_key]?
        raise Errors::UnknownOperator.new unless handler

        handler.call(args, scope_stack)
      when Array(JSON::Any)
        result = raw.map { |item| call(item, scope_stack) }
        JSON::Any.new(result)
      else
        rule
      end
    end
  end
end
