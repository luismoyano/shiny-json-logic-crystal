module ShinyJsonLogic
  module Operations
    module Try
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        items = Base.wrap_nil(args)
        last_error = nil

        items.each do |item|
          if last_error
            scope_stack << JSON::Any.new({} of String => JSON::Any)  # intermediate
            scope_stack << JSON::Any.new(last_error.payload)
          end

          begin
            result = Engine.call(item, scope_stack)
            if last_error
              scope_stack.pop
              scope_stack.pop
            end
            return result
          rescue e : Errors::Base
            if last_error
              scope_stack.pop
              scope_stack.pop
            end
            last_error = e
          end
        end

        raise last_error.not_nil! if last_error
        JSON::Any.new(nil)
      end
    end
  end
end

ShinyJsonLogic::Engine.register("try") { |a, s| ShinyJsonLogic::Operations::Try.call(a, s) }
