# frozen_string_literal: true

RSpec.describe Users::SyncAllTestingJob, type: :job do
  let!(:existing_users) { FactoryBot.create_list :user, 5 }

  it "executes as expected" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Users::SyncTestingJob).at_least(existing_users.size).times
  end
end
