module ShinyJsonLogic
  module Operations
    module Substring
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raw = args.raw
        raise Errors::InvalidArguments.new unless raw.is_a?(Array(JSON::Any)) && raw.size >= 2

        str = Strings.any_to_s(Engine.call(raw[0], scope_stack))
        start_any = Engine.call(raw[1], scope_stack)
        start = case start_any.raw
                when Float64 then start_any.as_f.to_i
                when Int64   then start_any.as_i64.to_i
                else 0
                end

        length = if raw.size > 2 && !raw[2].raw.nil?
          len_any = Engine.call(raw[2], scope_stack)
          case len_any.raw
          when Float64 then len_any.as_f.to_i
          when Int64   then len_any.as_i64.to_i
          else str.size
          end
        else
          str.size
        end

        str_size = str.size
        start += str_size if start < 0
        start = 0 if start < 0
        return JSON::Any.new("") if start >= str_size

        finish = length < 0 ? str_size + length : start + length
        finish = str_size if finish > str_size
        result = start < finish ? str[start...finish] : ""
        JSON::Any.new(result)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("substr") { |a, s| ShinyJsonLogic::Operations::Substring.call(a, s) }
