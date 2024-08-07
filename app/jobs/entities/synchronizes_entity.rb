# frozen_string_literal: true

module Entities
  # Iterates all associated records for a specific model via `find_each`
  # and synchronizes them into their associated {Entity} table.
  #
  # @see Entities::Sync
  module SynchronizesEntity
    extend ActiveSupport::Concern

    include JobIteration::Iteration

    included do
      extend Dry::Core::ClassAttributes

      unique_job! by: :job

      # @!scope class
      # @!attribute [r] model
      # The model this job operates on.
      # @return [Class]
      defines :model

      queue_as :maintenance

      delegate :base_scope, to: :class
    end

    # @param [String] cursor
    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        base_scope.all,
        cursor:,
      )
    end

    # @param [SyncsEntity] entity
    # @return [void]
    def each_iteration(entity)
      Entities::SynchronizeJob.perform_later entity
    end

    class_methods do
      # @return [ActiveRecord::Relation]
      def base_scope
        model.all
      end
    end
  end
end
