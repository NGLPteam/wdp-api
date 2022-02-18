# frozen_string_literal: true

module Schemas
  module References
    # Types tied to referencing models from within a schema.
    module Types
      include Dry.Types

      extend Shared::EnhancedTypes

      Collected = Any.constrained(schematic_collected_references: true).constructor ->(input, &block) do
        WDPAPI::Container["schemas.references.parse_collected"].call(input).value_or do
          block.call
        end
      end

      CollectedMap = Hash.map(String, Models::Types::ModelList)

      Scalar = Any.constrained(schematic_scalar_reference: true).constructor ->(input, &block) do
        WDPAPI::Container["schemas.references.parse_scalar"].call(input).value_or do
          block.call
        end
      end

      ScalarMap = Hash.map(String, Models::Types::Model.optional)
    end
  end
end
