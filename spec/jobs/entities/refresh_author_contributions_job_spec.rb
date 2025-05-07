# frozen_string_literal: true

RSpec.describe Entities::RefreshAuthorContributionsJob, type: :job do
  it "does not raise an error" do
    expect do
      described_class.perform_now
    end.to execute_safely
  end
end
