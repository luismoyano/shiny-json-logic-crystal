module ShinyJsonLogic
  module Operations
    module Var
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        # Fast path: simple string key
        if args.raw.is_a?(String)
          key = args.as_s
          current = scope_stack.last
          return current if key.empty?
          return fetch_value(current, key)
        end

        items = Base.wrap_nil(args)
        key_any = items.size > 0 ? Engine.call(items[0], scope_stack) : JSON::Any.new(nil)
        default = items.size > 1 ? Engine.call(items[1], scope_stack) : JSON::Any.new(nil)
        current = scope_stack.last

        raw_key = key_any.raw
        if raw_key.nil? || (raw_key.is_a?(String) && raw_key.empty?)
          return current
        end

        key = raw_key.to_s
        result = fetch_value_or_missing(current, key)
        # Crystal nil = key not found → use default
        # JSON::Any.new(nil) = key exists with JSON null → respect it
        result.nil? ? default : result
      rescue
        JSON::Any.new(nil)
      end

      # Returns nil (Crystal nil) if key not found, JSON::Any if key exists (even with JSON null)
      def self.fetch_value_or_missing(obj : JSON::Any, key : String) : JSON::Any?
        return nil if obj.raw.nil?

        # Dot notation
        if key.includes?(".")
          current = obj
          key.split(".").each do |segment|
            result = ScopeStack.fetch_key(current, segment)
            return nil if result.nil?
            current = result
          end
          return current
        end

        ScopeStack.fetch_key(obj, key)
      end

      # For fast path (no default needed) — absent key returns JSON null
      def self.fetch_value(obj : JSON::Any, key : String) : JSON::Any
        fetch_value_or_missing(obj, key) || JSON::Any.new(nil)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("var") { |args, scope_stack| ShinyJsonLogic::Operations::Var.call(args, scope_stack) }
