# frozen_string_literal: true

RSpec.describe Harvesting::ExtractRecordsJob, type: :job do
  let_it_be(:target_entity, refind: true) { FactoryBot.create :collection, :journal }

  let_it_be(:valid_harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

  let_it_be(:broken_harvest_source, refind: true) { FactoryBot.create :harvest_source, :broken_oai }

  let(:expected_record_count) { 0 }

  context "with a valid harvest source" do
    let_it_be(:harvest_attempt) { valid_harvest_source.create_attempt!(target_entity:) }

    let(:expected_record_count) { Harvesting::Testing::OAI::JATSRecord.count }

    it "can extract records and enqueue them for further processing" do
      expect do
        described_class.perform_now(harvest_attempt)
      end.to change(HarvestRecord, :count).by(expected_record_count)
        .and change(HarvestRecord.pending, :count).by(expected_record_count)
        .and keep_the_same(HarvestMessage.error, :count)
        .and keep_the_same(HarvestRecord.active, :count)
        .and have_enqueued_job(Harvesting::Records::ExtractEntitiesJob).exactly(expected_record_count).times
        .and change { harvest_attempt.current_state(force_reload: true) }.from("pending").to("extracted")
    end
  end

  context "with a broken harvest source" do
    let_it_be(:harvest_attempt) { broken_harvest_source.create_attempt!(target_entity:) }

    it "extracts no records and enqueues no further jobs" do
      expect do
        described_class.perform_now(harvest_attempt)
      end.to keep_the_same(HarvestRecord, :count)
        .and have_enqueued_no_jobs(Harvesting::Records::ExtractEntitiesJob)
        .and change(HarvestMessage.fatal, :count).by_at_least(1)
    end
  end
end
