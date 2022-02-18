# frozen_string_literal: true

module Schemas
  module Properties
    module References
      # A schematic reference to a single model.
      #
      # @see SchematicScalarReference
      module Scalar
        extend ActiveSupport::Concern

        include Schemas::Properties::References::Model

        def extract_raw_value_from(context)
          context.scalar_reference(full_path)
        end

        def write_values_within!(context)
          context.write_scalar_reference! path
        end
      end
    end
  end
end
