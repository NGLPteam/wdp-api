# frozen_string_literal: true

RSpec.describe Harvesting::ExtractRecordsJob, type: :job do
  let(:harvest_attempt) { FactoryBot.create :harvest_attempt }

  it_behaves_like "a pass-through operation job", "harvesting.actions.extract_records" do
    let(:job_arg) { harvest_attempt }

    let(:operation_args) { [harvest_attempt, { skip_prepare: true }] }

    it "reprocesses the attempt after extraction" do
      expect_running_the_job.to have_enqueued_job(Harvesting::ReprocessAttemptJob).with(harvest_attempt).once
    end
  end
end
