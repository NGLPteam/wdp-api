# frozen_string_literal: true

RSpec.xdescribe HarvestMappingPolicy, type: :policy do
  subject { described_class.new(identity, harvest_mapping) }

  let_it_be(:harvest_mapping) { FactoryBot.create :harvest_mapping }
end
