# frozen_string_literal: true

RSpec.describe System::CollectPgHeroSpaceStatsJob, type: :job do
  it "performs without issue" do
    expect do
      described_class.perform_now
    end.to execute_safely
  end
end
