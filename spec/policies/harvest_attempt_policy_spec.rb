# frozen_string_literal: true

RSpec.xdescribe HarvestAttemptPolicy, type: :policy do
  subject { described_class.new(identity, harvest_attempt) }

  let_it_be(:harvest_attempt) { FactoryBot.create :harvest_attempt }
end
