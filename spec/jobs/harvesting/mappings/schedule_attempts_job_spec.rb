# frozen_string_literal: true

RSpec.describe Harvesting::Mappings::ScheduleAttemptsJob, type: :job do
  let_it_be(:harvest_mapping) { FactoryBot.create(:harvest_mapping, :scheduled) }

  it_behaves_like "a pass-through operation job", "harvesting.mappings.schedule_attempts" do
    let(:job_arg) { harvest_mapping }
  end
end
