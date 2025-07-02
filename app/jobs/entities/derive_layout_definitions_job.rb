# frozen_string_literal: true

module Entities
  # @see Entities::DeriveLayoutDefinitions
  class DeriveLayoutDefinitionsJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform
      call_operation!("entities.derive_layout_definitions")
    end
  end
end
