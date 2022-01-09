# frozen_string_literal: true

module Entities
  # @see Entities::CalculateAuthorizing
  class CalculateAuthorizingJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform(**options)
      call_operation! "entities.calculate_authorizing", **options
    end
  end
end
