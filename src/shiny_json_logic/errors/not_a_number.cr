module ShinyJsonLogic
  module Errors
    class NotANumber < Base
      def initialize
        super("NaN")
      end
    end
  end
end
