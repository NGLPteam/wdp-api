# frozen_string_literal: true

RSpec.describe Users::SyncTestingJob, type: :job do
  let!(:user) { FactoryBot.create :user }

  it "executes as expected" do
    success = Dry::Monads.Success user

    allow(user).to receive(:sync_testing!).and_return(success)

    expect do
      described_class.perform_now user
    end.to execute_safely

    expect(user).to have_received(:sync_testing!).exactly(:once)
  end
end
