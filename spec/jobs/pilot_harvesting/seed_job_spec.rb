# frozen_string_literal: true

RSpec.describe PilotHarvesting::SeedJob, type: :job do
  it_behaves_like "a pass-through operation job", "pilot_harvesting.seed" do
    let(:job_arg) { :escholarship }
  end
end
