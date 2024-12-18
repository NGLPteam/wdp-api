# frozen_string_literal: true

module OrderingInvalidations
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    OrderingInvalidation = ModelInstance("OrderingInvalidation")
  end
end
