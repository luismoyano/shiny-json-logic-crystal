module ShinyJsonLogic
  module Operations
    module MinMax
      def self.resolve(args : JSON::Any, scope_stack : Array(JSON::Any), op : Symbol) : JSON::Any
        # If args is an operation, evaluate it first
        raw = args.raw
        items = if raw.is_a?(Hash(String, JSON::Any)) && !raw.empty? && Engine::OPERATIONS.has_key?(raw.first_key)
          evaluated = Base.wrap_nil(Engine.call(args, scope_stack))
          evaluated
        else
          Base.wrap_nil(args).map { |item| Engine.call(item, scope_stack) }
        end

        raise Errors::InvalidArguments.new if items.empty?

        # Validate all are numeric
        items.each do |item|
          r = item.raw
          raise Errors::InvalidArguments.new unless r.is_a?(Float64) || r.is_a?(Int64)
        end

        best = items[0]
        best_f = to_f(best)

        i = 1
        while i < items.size
          v = items[i]
          vf = to_f(v)
          if op == :min
            if vf < best_f
              best = v
              best_f = vf
            end
          else
            if vf > best_f
              best = v
              best_f = vf
            end
          end
          i += 1
        end
        best
      end

      def self.to_f(v : JSON::Any) : Float64
        r = v.raw
        r.is_a?(Float64) ? r : r.as(Int64).to_f
      end
    end
  end
end
