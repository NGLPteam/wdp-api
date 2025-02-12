# frozen_string_literal: true

RSpec.xdescribe HarvestSetPolicy, type: :policy do
  subject { described_class.new(identity, harvest_set) }

  let_it_be(:harvest_set) { FactoryBot.create :harvest_set }
end
