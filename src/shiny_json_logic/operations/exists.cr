module ShinyJsonLogic
  module Operations
    module Exists
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        current = scope_stack.last
        operands = Base.wrap_nil(args)
        operands.each do |op|
          segment = Engine.call(op, scope_stack).raw.to_s
          raw = current.raw
          case raw
          when Hash(String, JSON::Any)
            return JSON::Any.new(false) unless raw.has_key?(segment)
            current = raw[segment]
          else
            return JSON::Any.new(false)
          end
        end
        JSON::Any.new(true)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("exists") { |args, scope_stack| ShinyJsonLogic::Operations::Exists.call(args, scope_stack) }
