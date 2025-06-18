# frozen_string_literal: true

RSpec.describe Testing::QuickJob, type: :job do
  it "times out very rapidly" do
    expect do
      expect(described_class.perform_now).to be_a_kind_of(ApplicationJob::JobTimeoutError)
    end.to execute_safely
  end
end
