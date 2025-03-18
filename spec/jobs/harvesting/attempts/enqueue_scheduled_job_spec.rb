# frozen_string_literal: true

RSpec.describe Harvesting::Attempts::EnqueueScheduledJob, type: :job do
  let_it_be(:scheduled_at) do
    base = Time.current.at_beginning_of_hour

    base + 1.hour + 30.minutes
  end

  let_it_be(:harvest_attempt) do
    FactoryBot.create(
      :harvest_attempt,
      mode: :scheduled,
      scheduling_key: "123456",
      scheduled_at:
    ).tap do |attempt|
      attempt.transition_to :scheduled
    end
  end

  it "enqueues attempts happening in the next hour" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Harvesting::ExtractRecordsJob).with(harvest_attempt).once
  end
end
