# frozen_string_literal: true

module Analytics
  class SimulatorObserver
    include Redis::Objects

    hash_key :entities, expireat: -> { 1.day.from_now }

    hash_key :visitors, expireat: -> { 1.day.from_now }

    counter :simulations, expire_at: -> { 1.day.from_now }

    sorted_set :runtimes

    def id
      "analytics"
    end

    # @param [Entity] entity
    # @param [FakeVisitor] fake_visitor
    # @return [void]
    def observe!(entity, fake_visitor, runtime)
      entity_id = entity.id
      visitor_id = fake_visitor.id

      entities.incr(entity_id)
      visitors.incr(visitor_id)
      simulations.increment

      runtime_key = "#{entity_id}:#{visitor_id}"

      runtimes[runtime_key] = runtime

      return nil
    end
  end
end
