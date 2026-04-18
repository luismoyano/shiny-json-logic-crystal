module ShinyJsonLogic
  module Operations
    module Base
      def self.wrap(value : JSON::Any) : Array(JSON::Any)
        raw = value.raw
        if raw.is_a?(Array(JSON::Any))
          raw
        else
          [value]
        end
      end

      def self.wrap_nil(value : JSON::Any) : Array(JSON::Any)
        raw = value.raw
        case raw
        when Nil
          [] of JSON::Any
        when Array(JSON::Any)
          raw
        else
          [value]
        end
      end
    end
  end
end
