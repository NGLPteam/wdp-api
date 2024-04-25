# frozen_string_literal: true

module Analytics
  # This will run through _all_ entities that lack any analytics
  # in the system and generate fake visitor histories for them.
  class SimulateAllVisitsJob < ApplicationJob
    queue_as :entities

    include JobIteration::Iteration

    # @return [void]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        ::Entity.real.includes(:hierarchical).sans_analytics,
        cursor:,
      )
    end

    # @param [Entity] source
    # @return [void]
    def each_iteration(source)
      entity = source.hierarchical

      FakeVisitor.find_each_in_sequence do |fake_visitor|
        Analytics::SimulateFakeEntityHistoryJob.perform_later entity, fake_visitor
      end
    end
  end
end
