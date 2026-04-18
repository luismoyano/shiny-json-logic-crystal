module ShinyJsonLogic
  module Operations
    module Reduce
      def self.call(args : JSON::Any, scope_stack : Array(JSON::Any)) : JSON::Any
        raw = args.raw
        raise Errors::InvalidArguments.new unless raw.is_a?(Array(JSON::Any)) && raw.size >= 2

        filter = raw[1]
        collection_raw = Engine.call(raw[0], scope_stack).raw
        collection = collection_raw.is_a?(Array(JSON::Any)) ? collection_raw : [] of JSON::Any

        accumulator = raw.size > 2 ? Engine.call(raw[2], scope_stack) : JSON::Any.new(nil)

        reduce_scope = {"current" => JSON::Any.new(nil), "accumulator" => JSON::Any.new(nil)}
        reduce_scope_any = JSON::Any.new(reduce_scope)
        scope_stack << reduce_scope_any

        begin
          collection.each do |item|
            reduce_scope["current"] = item
            reduce_scope["accumulator"] = accumulator
            accumulator = Engine.call(filter, scope_stack)
          end
        ensure
          scope_stack.pop
        end

        accumulator
      end
    end
  end
end

ShinyJsonLogic::Engine.register("reduce") { |a, s| ShinyJsonLogic::Operations::Reduce.call(a, s) }
