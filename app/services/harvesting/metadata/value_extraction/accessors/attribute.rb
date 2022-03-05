# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module Accessors
        # Access an attribute from the source via a specified attribute name.
        #
        # The prospective attribute must be publicly-accessible.
        class Attribute < Harvesting::Metadata::ValueExtraction::Accessor
          param :attribute_name, Harvesting::Types::Coercible::Symbol

          # @param [Object] source
          # @return [Dry::Monads::Success(Object)]
          def extract(source)
            Success source.public_send attribute_name
          end

          # @note Ensure our source actually responds to the method
          def source_type
            super.constrained(respond_to: attribute_name)
          end
        end
      end
    end
  end
end
