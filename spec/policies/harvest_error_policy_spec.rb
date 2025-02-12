# frozen_string_literal: true

RSpec.xdescribe HarvestErrorPolicy, type: :policy do
  subject { described_class.new(identity, harvest_error) }

  let_it_be(:harvest_error) { FactoryBot.create :harvest_error }
end
