# frozen_string_literal: true

module Templates
  module Definitions
    class AbstractEnumValue < Shale::Type::Value
      extend Dry::Core::ClassAttributes

      DryEnumType = ::Templates::Types.Instance(::Dry::Types::Enum)

      NullEnum = ::Templates::Types::Instance(Class).enum(Pathname)

      # @!attribute [r] enum_type
      # @!scope class
      # An enum type for this value that represents all the possible values
      # that can be passed in.
      # @return [Dry::Types::Enum]
      defines :enum_type, type: DryEnumType

      enum_type NullEnum

      class << self
        # Set the {.enum_type} for this class.
        #
        # @api private
        # @param [Dry::Types::Enum] enum
        # @return [void]
        def accepts_enum!(enum)
          enum_type enum
        end

        # @param [#to_s] value a potential value for the associated {.enum_type}.
        # @return [Object] one of the accepted enum values
        def cast(value)
          return nil if value.blank?

          enum_type[value]
        end
      end
    end
  end
end
