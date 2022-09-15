# frozen_string_literal: true

module Analytics
  # @api private
  class SimulateFakeEntityHistory
    include Dry::Monads[:result]

    # @param [HierarchicalEntity] entity
    # @param [FakeVisitor] fake_visitor
    # @return [void]
    def call(entity, fake_visitor)
      options = fake_visitor.to_simulator_options

      simulator = Analytics::FakeEntityVisitHistorySimulator.new(
        entity,
        **options
      )

      simulator.generate!

      Success()
    end
  end
end
