# frozen_string_literal: true

RSpec.describe System::CleanPgHeroQueryStatsJob, type: :job do
  it "performs without issue" do
    expect do
      described_class.perform_now
    end.to execute_safely
  end
end
