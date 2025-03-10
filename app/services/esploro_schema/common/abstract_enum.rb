# frozen_string_literal: true

module EsploroSchema
  module Common
    # There are a number of enumerated value types that come from the schema.
    #
    # @abstract
    class AbstractEnum < Lutaml::Model::Type::String
      extend Dry::Core::ClassAttributes

      include Dry::Core::Constants

      defines :allowed_values, type: EsploroSchema::Types::StringishList

      defines :enum_type, type: EsploroSchema::Types::DryType

      allowed_values EMPTY_ARRAY

      enum_type EsploroSchema::Types::Any

      class << self
        # @param [#to_s, nil] raw_value
        # @raise [Lutaml::Model::InvalidValueError]
        # @return [String, nil]
        def cast(raw_value)
          return nil if raw_value.nil?

          value = super(raw_value)

          enum_type[value]
        rescue Dry::Types::ConstraintError
          raise Lutaml::Model::InvalidValueError.new(self, raw_value, allowed_values)
        end

        # Define the enum type that we will use for this simple type.
        #
        # @param [Dry::Types::Enum] raw_type
        # @return [void]
        def uses!(raw_type)
          # Ensure that we receive an enum type.
          enum_type EsploroSchema::Types::DryEnum[raw_type]

          values = EsploroSchema::Types::StringishList[enum_type]

          allowed_values values
        end
      end
    end
  end
end
