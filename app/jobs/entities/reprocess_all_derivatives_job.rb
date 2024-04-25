# frozen_string_literal: true

module Entities
  class ReprocessAllDerivativesJob < ApplicationJob
    queue_as :maintenance

    include JobIteration::Iteration

    unique_job! by: :job

    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        ::Entity.real.preload(:hierarchical),
        cursor:,
      )
    end

    # @param [Entity] source
    # @return [void]
    def each_iteration(source)
      entity = source.hierarchical

      Entities::ReprocessDerivativesJob.perform_later entity
    end
  end
end
