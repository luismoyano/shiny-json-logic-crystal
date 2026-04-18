module ShinyJsonLogic
  module Operations
    module Numerics
      def self.numerify(value : JSON::Any) : Float64
        raw = value.raw
        case raw
        when Float64 then raw
        when Int64   then raw.to_f
        when Bool    then raw ? 1.0 : 0.0
        when Nil     then 0.0
        when String
          return 0.0 if raw.empty?

          f = raw.to_f?
          return f if f

          i = raw.to_i64?
          return i.to_f if i
          raise Errors::NotANumber.new
        when Array(JSON::Any), Hash(String, JSON::Any)
          raise Errors::NotANumber.new
        else
          raise Errors::InvalidArguments.new
        end
      end

      def self.numerify_for_comparison(value : JSON::Any) : JSON::Any
        raw = value.raw
        case raw
        when Float64, Int64, Bool, Nil then value
        when String
          f = raw.to_f?
          i = raw.to_i64?
          if f
            JSON::Any.new(f)
          elsif i
            JSON::Any.new(i.to_f)
          else
            value
          end
        else
          value
        end
      end

      def self.compare(a : JSON::Any, b : JSON::Any) : Float64?
        ra = a.raw
        rb = b.raw

        if ra.is_a?(Array) || ra.is_a?(Hash) || rb.is_a?(Array) || rb.is_a?(Hash)
          return nil
        end

        na = numerify_for_comparison(a)
        nb = numerify_for_comparison(b)

        rna = na.raw
        rnb = nb.raw

        if (rna.is_a?(Float64) || rna.is_a?(Int64)) && (rnb.is_a?(Float64) || rnb.is_a?(Int64))
          fa = rna.is_a?(Float64) ? rna : rna.to_f
          fb = rnb.is_a?(Float64) ? rnb : rnb.to_f
          return fa - fb
        end

        if rna.is_a?(String) && rnb.is_a?(String)
          return (rna <=> rnb).to_f
        end

        nil
      end

      def self.strict_cast(value : JSON::Any) : Float64 | String | Bool | Nil
        raw = value.raw
        case raw
        when Float64 then raw
        when Int64   then raw.to_f
        when String  then raw
        when Bool    then raw
        when Nil     then nil
        else              nil
        end
      end

      def self.numeric_result(value : Float64) : JSON::Any
        raise Errors::NotANumber.new if value.nan? || value.infinite?
        if value == value.floor && value.abs < 1e15
          JSON::Any.new(value.to_i64)
        else
          JSON::Any.new(value)
        end
      end

      def self.resolve_arith_args(args : JSON::Any, scope_stack : Array(JSON::Any)) : Array(JSON::Any)
        raw = args.raw
        case raw
        when Array(JSON::Any)
          raw.map { |item| Engine.call(item, scope_stack) }
        when Hash(String, JSON::Any)
          if !raw.empty? && Engine::OPERATIONS.has_key?(raw.first_key)
            result = Engine.call(args, scope_stack)
            result_raw = result.raw
            result_raw.is_a?(Array(JSON::Any)) ? result_raw : [result]
          else
            [args]
          end
        when Nil
          [JSON::Any.new(nil)]
        else
          [args]
        end
      end
    end
  end
end
