# frozen_string_literal: true

module StaleEntities
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    StaleEntity = ModelInstance("StaleEntity")
  end
end
