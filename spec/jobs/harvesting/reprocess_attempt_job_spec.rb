# frozen_string_literal: true

RSpec.describe Harvesting::ReprocessAttemptJob, type: :job do
  let!(:harvest_attempt) { FactoryBot.create :harvest_attempt }
  let!(:harvest_records) { FactoryBot.create_list :harvest_record, 2, harvest_attempt: }

  it "will enqueue a job for each record in the attempt" do
    expect do
      described_class.perform_now harvest_attempt
    end.to have_enqueued_job(Harvesting::UpsertEntitiesForRecordJob).exactly(harvest_records.size).times
  end
end
