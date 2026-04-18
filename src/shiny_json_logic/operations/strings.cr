module ShinyJsonLogic
  module Operations
    module Strings
      def self.any_to_s(v : JSON::Any) : String
        raw = v.raw
        case raw
        when Nil     then ""
        when Bool    then raw.to_s
        when Float64 then raw == raw.floor && raw.abs < 1e15 ? raw.to_i64.to_s : raw.to_s
        when Int64   then raw.to_s
        else              raw.to_s
        end
      end
    end
  end
end
