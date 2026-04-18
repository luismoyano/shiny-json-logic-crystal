module ShinyJsonLogic
  module Operations
    module Iterables
      def self.iter_collection(args : JSON::Any, scope_stack : Array(JSON::Any)) : Array(JSON::Any)
        raw = args.raw
        raise Errors::InvalidArguments.new unless raw.is_a?(Array(JSON::Any))
        collection_raw = Engine.call(raw[0], scope_stack).raw
        collection_raw.is_a?(Array(JSON::Any)) ? collection_raw : [] of JSON::Any
      end

      def self.iter_filter(args : JSON::Any) : JSON::Any?
        raw = args.raw
        return nil unless raw.is_a?(Array(JSON::Any))
        raw.size > 1 ? raw[1] : nil
      end
    end
  end
end
