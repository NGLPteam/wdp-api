# frozen_string_literal: true

module Seeding
  Brokerage = Seeding::Brokers::DSL::RootBuilder.new.build do
    community do
      handles_schema! "default:community"
    end

    collection do
      handles_schema! "default:collection"
      handles_schema! "nglp:journal"
      handles_schema! "nglp:series"
      handles_schema! "nglp:unit"
    end
  end
end
