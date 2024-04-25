# frozen_string_literal: true

module Entities
  # @see Audits::MismatchedEntitySchema
  class AuditMismatchedSchemasJob < ApplicationJob
    include JobIteration::Iteration

    queue_as :maintenance

    unique_job! by: :job

    # @param [String] cursor
    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        Audits::MismatchedEntitySchema.preload(:hierarchical),
        cursor:,
      )
    end

    # @param [Audits::MismatchedEntitySchema] audited_model
    # @return [void]
    def each_iteration(audited_model)
      call_operation! "entities.sync", audited_model.hierarchical
    end
  end
end
