module ShinyJsonLogic
  module Operations
    module MissingSome
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raw = args.raw
        raise Errors::InvalidArguments.new unless raw.is_a?(Array(JSON::Any)) && raw.size >= 2

        min_required_any = Engine.call(raw[0], scope_stack)
        min_required = case min_required_any.raw
                       when Int64   then min_required_any.as_i64.to_i
                       when Float64 then min_required_any.as_f.to_i
                       else 0
                       end

        raw_keys_any = Engine.call(raw[1], scope_stack)
        keys = Base.wrap_nil(raw_keys_any).map { |k| k.raw.to_s }

        current = scope_stack.last
        cur_raw = current.raw
        return JSON::Any.new(keys.map { |k| JSON::Any.new(k) }) unless cur_raw.is_a?(Hash(String, JSON::Any))

        present = keys.select { |k| cur_raw.has_key?(k) }
        result = present.size >= min_required ? [] of String : (keys - present)
        JSON::Any.new(result.map { |k| JSON::Any.new(k) })
      end
    end
  end
end

ShinyJsonLogic::Engine.register("missing_some") { |args, scope_stack| ShinyJsonLogic::Operations::MissingSome.call(args, scope_stack) }
