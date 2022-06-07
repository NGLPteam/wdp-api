# frozen_string_literal: true

module Entities
  # @see Audits::MismatchedEntitySchema
  class AuditMismatchedSchemasJob < ApplicationJob
    include JobIteration::Iteration

    queue_as :maintenance

    unique :until_and_while_executing, lock_ttl: 5.minutes, runtime_lock_ttl: 5.minutes, on_conflict: :log, on_runtime_conflict: :log

    # @param [String] cursor
    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        Audits::MismatchedEntitySchema.preload(:hierarchical),
        cursor: cursor,
      )
    end

    # @param [Audits::MismatchedEntitySchema] audited_model
    # @return [void]
    def each_iteration(audited_model)
      call_operation! "entities.sync", audited_model.hierarchical
    end
  end
end
