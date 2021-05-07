# frozen_string_literal: true

module Types
  class SlugType < Types::BaseScalar
    description "A slug that can identify a record in context"

    class << self
      def coerce_input(input_value, context)
        WDPAPI::Container["slugs.decode_id"].call(input_value).value_or(nil)
      end

      def coerce_result(ruby_value, context)
        WDPAPI::Container["slugs.encode_id"].call(ruby_value).value_or(nil)
      end
    end
  end
end
