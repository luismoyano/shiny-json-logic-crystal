module ShinyJsonLogic
  module Operations
    module Missing
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        wrapped = Base.wrap_nil(args)
        keys = [] of String

        wrapped.each do |item|
          evaluated = Engine.call(item, scope_stack)
          raw = evaluated.raw
          if raw.is_a?(Array(JSON::Any))
            raw.each { |k| keys << k.raw.to_s }
          else
            keys << raw.to_s
          end
        end

        current = scope_stack.last
        raw_current = current.raw
        return JSON::Any.new(keys.map { |k| JSON::Any.new(k) }) unless raw_current.is_a?(Hash(String, JSON::Any))

        existing = {} of String => Bool
        deep_keys(current, nil, existing)

        missing = keys.reject { |k| existing.has_key?(k) }
        JSON::Any.new(missing.map { |k| JSON::Any.new(k) })
      end

      def self.deep_keys(hash : JSON::Any, prefix : String?, acc : Hash(String, Bool))
        raw = hash.raw
        return unless raw.is_a?(Hash(String, JSON::Any))

        raw.each do |key, val|
          full_key = prefix ? "#{prefix}.#{key}" : key
          if val.raw.is_a?(Hash(String, JSON::Any))
            deep_keys(val, full_key, acc)
          else
            acc[full_key] = true
          end
        end
      end
    end
  end
end

ShinyJsonLogic::Engine.register("missing") { |args, scope_stack| ShinyJsonLogic::Operations::Missing.call(args, scope_stack) }
