# frozen_string_literal: true

module Schemas
  module References
    # Types tied to referencing models from within a schema.
    module Types
      include Dry.Types

      extend Shared::EnhancedTypes

      CollectedMap = Hash.map(String, Models::Types::ModelList)

      ScalarMap = Hash.map(String, Models::Types::Model.optional)
    end
  end
end
