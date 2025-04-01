# frozen_string_literal: true

module Types
  class SlugType < Types::BaseScalar
    description "A slug that can identify a record in context"

    SCHEMA_SLUG_PATTERN = /
    \A(?:[a-z_]+):(?:[a-z_]+)(?::[^:]+)?\z
    /x

    class << self
      def coerce_input(input_value, context)
        case input_value
        when SCHEMA_SLUG_PATTERN then input_value
        when AnonymousUser::ID then AnonymousUser::ID
        else
          Support::System["slugs.decode_id"].call(input_value).value_or(nil)
        end
      end

      def coerce_result(ruby_value, context)
        case ruby_value
        when SCHEMA_SLUG_PATTERN then ruby_value
        when AnonymousUser::ID then AnonymousUser::ID
        else
          Support::System["slugs.encode_id"].call(ruby_value).value_or(nil)
        end
      end
    end
  end
end
