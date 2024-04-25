# frozen_string_literal: true

module Entities
  # Reprocess attachment derivatives for an individual {HierarchicalEntity}
  class ReprocessDerivativesJob < ApplicationJob
    queue_as :maintenance

    retry_on Redis::TimeoutError, wait: :exponentially_longer

    unique_job! by: :all_args

    # @param [HierarchicalEntity] entity
    # @return [void]
    def perform(entity)
      names = %i[hero_image thumbnail]

      names << :logo if entity.kind_of?(Community)

      names.each do |name|
        Entities::ReprocessDerivativeJob.perform_later entity, name
      end
    end
  end
end
