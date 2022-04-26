# frozen_string_literal: true

module Seeding
  module Brokers
    module DSL
      class CommunityBuilder < EntityBuilder
        builds! Seeding::Brokers::CommunityBroker
      end
    end
  end
end
