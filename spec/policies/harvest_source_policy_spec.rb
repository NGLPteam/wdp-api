# frozen_string_literal: true

RSpec.xdescribe HarvestSourcePolicy, type: :policy do
  subject { described_class.new(identity, harvest_source) }

  let_it_be(:harvest_source) { FactoryBot.create :harvest_source }
end
