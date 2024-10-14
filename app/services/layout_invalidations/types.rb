# frozen_string_literal: true

module LayoutInvalidations
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    LayoutInvalidation = ModelInstance("LayoutInvalidation")
  end
end
