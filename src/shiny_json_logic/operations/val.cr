module ShinyJsonLogic
  module Operations
    module Val
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raw = args.raw
        return scope_stack.last if raw.nil?

        # single string key
        if raw.is_a?(String)
          return ScopeStack.fetch_key(scope_stack.last, raw) || JSON::Any.new(nil)
        end

        raw_keys = Base.wrap_nil(args)

        # {"val": []} or {"val": [nil]}
        if raw_keys.empty? || (raw_keys.size == 1 && raw_keys[0].raw.nil?)
          return scope_stack.last
        end

        first_key = raw_keys.first

        # Scope navigation: {"val": [[N], "key", ...]}
        if first_key.raw.is_a?(Array(JSON::Any))
          level_indicator = first_key.as_a.first?.try(&.raw.as?(Int64)) || first_key.as_a.first?.try(&.raw.as?(Float64).try(&.to_i64)) || 0_i64
          levels = level_indicator.abs.to_i32
          keys = [] of String
          i = 1
          while i < raw_keys.size
            keys << Engine.call(raw_keys[i], scope_stack).raw.to_s
            i += 1
          end
          return ScopeStack.resolve(scope_stack, levels, keys)
        end

        # Normal: {"val": ["key1", "key2"]}
        keys = raw_keys.map { |k| Engine.call(k, scope_stack).raw.to_s }
        ScopeStack.dig_value(scope_stack.last, keys)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("val") { |args, scope_stack| ShinyJsonLogic::Operations::Val.call(args, scope_stack) }
