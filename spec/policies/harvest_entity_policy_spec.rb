# frozen_string_literal: true

RSpec.xdescribe HarvestEntityPolicy, type: :policy do
  subject { described_class.new(identity, harvest_entity) }

  let_it_be(:harvest_entity) { FactoryBot.create :harvest_entity }
end
