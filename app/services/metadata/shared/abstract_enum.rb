# frozen_string_literal: true

module Metadata
  module Shared
    # @abstract
    class AbstractEnum < Lutaml::Model::Type::String
      extend Dry::Core::ClassAttributes

      defines :values, type: ::Metadata::Types::EnumeratedStringList

      class << self
        def cast(value)
          return nil if value.nil?

          value = super

          raise Lutaml::Model::InvalidValueError.new(self, value, values) unless values.include?(value)

          return value
        end

        private

        # @param [<String>] raw_values
        # @return [void]
        def values!(*raw_values)
          sanitized = ::Metadata::Types::EnumeratedStringList[raw_values.flatten.compact_blank]

          values sanitized.freeze
        end
      end
    end
  end
end
