# frozen_string_literal: true

module Communities
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Community = ModelInstance("Community")
  end
end
