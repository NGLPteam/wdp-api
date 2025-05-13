# frozen_string_literal: true

RSpec.describe Harvesting::Attempts::ExtractRecords, type: :operation do
  let_it_be(:target_entity, refind: true) { FactoryBot.create :collection, :journal }

  let_it_be(:valid_harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

  context "with a valid harvest source" do
    let_it_be(:harvest_attempt) { valid_harvest_source.create_attempt!(target_entity:) }

    let(:expected_record_count) { Harvesting::Testing::OAI::JATSRecord.count }

    it "can extract records" do
      expect do
        harvest_attempt.extract_records!
      end.to change(HarvestRecord, :count).by(expected_record_count)
        .and change(HarvestRecord.pending, :count).by(expected_record_count)
    end
  end
end
