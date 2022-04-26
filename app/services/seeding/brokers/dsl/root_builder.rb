# frozen_string_literal: true

module Seeding
  module Brokers
    module DSL
      class RootBuilder < Builder
        builds! Seeding::Brokers::RootBroker

        builds_nested! :community, with: Seeding::Brokers::DSL::CommunityBuilder
        builds_nested! :collection, with: Seeding::Brokers::DSL::CollectionBuilder
      end
    end
  end
end
