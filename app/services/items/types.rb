# frozen_string_literal: true

module Items
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Item = ModelInstance("Item")
  end
end
