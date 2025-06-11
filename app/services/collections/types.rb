# frozen_string_literal: true

module Collections
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Collection = ModelInstance("Collection")
  end
end
