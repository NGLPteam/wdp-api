# frozen_string_literal: true

RSpec.describe Entities::CalculateAuthorizingJob, type: :job do
  it "executes without issue" do
    expect do
      described_class.perform_now
    end.to execute_safely
  end
end
