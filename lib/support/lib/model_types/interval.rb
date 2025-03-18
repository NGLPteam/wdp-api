# frozen_string_literal: true

module Support
  module ModelTypes
    class Interval < ActiveModel::Type::Value
      include Support::ModelTypes::Common

      def cast_value(value)
        case value
        when ::ActiveSupport::Duration
          value
        when /\S+/
          ::ActiveSupport::Duration.parse(value)
        else
          super
        end
      end

      def serialize(value)
        case value
        when ::ActiveSupport::Duration
          value.iso8601(precision:)
        when ::Numeric
          # Sometimes operations on Times returns just float number of seconds so we need to handle that.
          # Example: Time.current - (Time.current + 1.hour) # => -3600.000001776 (Float)
          value.seconds.iso8601(precision:)
        else
          super
        end
      end
    end
  end
end
