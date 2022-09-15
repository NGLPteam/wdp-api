# frozen_string_literal: true

module Analytics
  # @see Analytics::SimulateFakeEntityHistory
  # @api private
  class SimulateFakeEntityHistoryJob < ApplicationJob
    queue_as :ahoy

    # @param [HierarchicalEntity] entity
    # @param [FakeVisitor] fake_visitor
    # @return [void]
    def perform(entity, fake_visitor)
      call_operation! "analytics.simulate_fake_entity_history", entity, fake_visitor
    end
  end
end
