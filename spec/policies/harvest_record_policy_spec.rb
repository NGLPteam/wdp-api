# frozen_string_literal: true

RSpec.xdescribe HarvestRecordPolicy, type: :policy do
  subject { described_class.new(identity, harvest_record) }

  let_it_be(:harvest_record) { FactoryBot.create :harvest_record }
end
