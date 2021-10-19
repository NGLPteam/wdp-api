# frozen_string_literal: true

RSpec.describe Users::SyncTestingJob, type: :job do
  let!(:existing_users) { FactoryBot.create_list :user, 5 }

  it "executes as expected" do
    call_count = 0

    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(User).to receive(:sync_testing!) { call_count += 1 }
    # rubocop:enable RSpec/AnyInstance

    expect do
      described_class.perform_now
    end.to execute_safely

    expect(call_count).to eq existing_users.size
  end
end
