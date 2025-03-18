# frozen_string_literal: true

RSpec.describe Harvesting::Mappings::ScheduleAllAttemptsJob, type: :job do
  let_it_be(:harvest_mapping) { FactoryBot.create(:harvest_mapping, :scheduled) }

  it "enqueues a job for each scheduled mapping" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Harvesting::Mappings::ScheduleAttemptsJob).once.with(harvest_mapping)
  end
end
