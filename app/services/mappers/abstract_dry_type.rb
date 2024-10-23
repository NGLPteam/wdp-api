# frozen_string_literal: true

module Mappers
  # @abstract
  class AbstractDryType < Shale::Type::Value
    extend Dry::Core::ClassAttributes

    # @!attribute [r] dry_type
    # @!scope class
    # A dry type
    # @return [Dry::Types::Type]
    defines :dry_type, type: Mappers::Types::DryType

    defines :default_value, type: Mappers::Types::Any.optional

    dry_type Mappers::Types::Any

    default_value nil

    class << self
      # Set the {.dry_type} for this class.
      #
      # @api private
      # @param [Dry::Types::Type] type
      # @return [void]
      def accepts_type!(type)
        dry_type type

        default_value type.value if type.default?
      end

      # @param [#to_s] value a potential value for the associated {.dry_type}.
      # @return [Object] one of the accepted enum values
      def cast(value)
        return default_value if value.blank?

        dry_type[value]
      end
    end
  end
end
