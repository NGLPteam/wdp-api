# frozen_string_literal: true

module Entities
  module SynchronizesEntity
    extend ActiveSupport::Concern

    include JobIteration::Iteration

    included do
      extend Dry::Core::ClassAttributes

      unique :until_and_while_executing, lock_ttl: 3.hours, on_conflict: :log

      defines :model

      queue_as :maintenance

      delegate :base_scope, to: :class
    end

    # @param [String] cursor
    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        base_scope.all,
        cursor: cursor,
      )
    end

    # @param [HierarchicalEntity] entity
    # @return [void]
    def each_iteration(entity)
      entity.sync_entity!
    end

    module ClassMethods
      def base_scope
        model.all
      end
    end
  end
end
