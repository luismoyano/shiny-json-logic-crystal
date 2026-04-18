module ShinyJsonLogic
  module Truthy
    def self.call(subject : JSON::Any) : Bool
      raw = subject.raw
      case raw
      when Bool    then raw
      when Int64   then raw != 0_i64
      when Float64 then raw != 0.0
      when String  then !raw.empty?
      when Nil     then false
      when Hash
        !raw.empty?
      when Array
        raw.any? { |item| call(item) }
      else
        true
      end
    end
  end
end
