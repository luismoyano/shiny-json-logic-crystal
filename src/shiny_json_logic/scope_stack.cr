module ShinyJsonLogic
  # ScopeStack helpers — scope_stack is a plain Array(JSON::Any).
  # The last element is the current scope (top of stack).
  #
  # Stack layout during iteration:
  #   Level 0: root data
  #   Level 1: iterator context {"index" => N}
  #   Level 2: current item
  #
  # val [[N], "key"] navigates N levels up from the top.
  module ScopeStack
    def self.resolve(stack : Array(JSON::Any), levels : Int32, keys : Array(String)) : JSON::Any
      target_index = stack.size - 1 - levels
      return JSON::Any.new(nil) if target_index < 0

      data = stack[target_index]
      keys.empty? ? data : dig_value(data, keys)
    end

    # Navigate a chain of keys into a JSON value. Returns JSON null if any key is missing.
    def self.dig_value(data : JSON::Any, keys : Array(String)) : JSON::Any
      obj = data
      keys.each do |key|
        result = fetch_key(obj, key)
        return JSON::Any.new(nil) if result.nil?
        obj = result
      end
      obj
    end

    # Fetch a single key from a JSON::Any (Hash or Array).
    # Returns nil (Crystal nil) if the key does not exist.
    # Returns JSON::Any if the key exists, even if its value is JSON null.
    def self.fetch_key(obj : JSON::Any, key : String) : JSON::Any?
      raw = obj.raw
      case raw
      when Hash(String, JSON::Any)
        raw.has_key?(key) ? raw[key] : nil
      when Array(JSON::Any)
        idx = key.to_i?
        return nil unless idx
        return nil if idx < 0 || idx >= raw.size
        raw[idx]
      else
        nil
      end
    end
  end
end
