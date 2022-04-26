# frozen_string_literal: true

module Seeding
  module Brokers
    module DSL
      class CollectionBuilder < EntityBuilder
        builds! Seeding::Brokers::CollectionBroker
      end
    end
  end
end
