# frozen_string_literal: true

RSpec.describe Harvesting::Sources::PruneEntitiesJob, type: :job do
  let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source }

  it_behaves_like "a pass-through operation job", "harvesting.sources.prune_entities" do
    let!(:job_arg) do
      harvest_source
    end
  end
end
