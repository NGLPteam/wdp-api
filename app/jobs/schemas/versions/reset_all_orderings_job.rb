# frozen_string_literal: true

module Schemas
  module Versions
    class ResetAllOrderingsJob < ApplicationJob
      include JobIteration::Iteration

      queue_as :maintenance

      def build_enumerator(schema_version, cursor:)
        enumerator_builder.active_record_on_records(
          Entity.actual.filtered_by_schema_version(schema_version).preload(:entity),
          cursor:,
        )
      end

      # @param [Entity] entity_record
      # @return [void]
      def each_iteration(entity_record, _schema_version)
        Schemas::Instances::ResetAllOrderingsJob.perform_later entity_record.entity
      end
    end
  end
end
