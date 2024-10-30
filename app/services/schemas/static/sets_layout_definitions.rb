# frozen_string_literal: true

module Schemas
  module Static
    module SetsLayoutDefinitions
      extend ActiveSupport::Concern

      included do
        include Dry::Effects.Reader(:skip_layout_invalidation, default: false)
        include Dry::Effects.State(:layout_definitions)
      end
    end
  end
end
