# frozen_string_literal: true

module Entities
  # @see Entities::PopulateVisibilities
  class PopulateVisibilitiesJob < ApplicationJob
    queue_as :maintenance

    unique_job! by: :job

    # @return [void]
    def perform
      call_operation! "entities.populate_visibilities"
    end
  end
end
