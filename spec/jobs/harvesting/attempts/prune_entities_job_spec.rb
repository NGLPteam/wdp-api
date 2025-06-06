# frozen_string_literal: true

RSpec.describe Harvesting::Attempts::PruneEntitiesJob, type: :job do
  let_it_be(:harvest_attempt, refind: true) { FactoryBot.create :harvest_attempt }

  it_behaves_like "a pass-through operation job", "harvesting.attempts.prune_entities" do
    let!(:job_arg) do
      harvest_attempt
    end
  end
end
