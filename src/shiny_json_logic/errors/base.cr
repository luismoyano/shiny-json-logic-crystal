module ShinyJsonLogic
  module Errors
    class Base < Exception
      getter type : String?
      getter payload : Hash(String, JSON::Any)

      def initialize(@type : String? = nil)
        super(@type)
        @payload = Hash(String, JSON::Any).new
        @payload["type"] = JSON::Any.new(@type) if @type
      end
    end
  end
end
