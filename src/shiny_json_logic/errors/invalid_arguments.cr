module ShinyJsonLogic
  module Errors
    class InvalidArguments < Base
      def initialize
        super("Invalid Arguments")
      end
    end
  end
end
