# frozen_string_literal: true

module Entities
  # @see Entities::PopulateVisibilities
  class PopulateVisibilitiesJob < ApplicationJob
    queue_as :maintenance

    unique :until_and_while_executing, lock_ttl: 10.minutes, on_conflict: :log

    # @return [void]
    def perform
      call_operation! "entities.populate_visibilities"
    end
  end
end
