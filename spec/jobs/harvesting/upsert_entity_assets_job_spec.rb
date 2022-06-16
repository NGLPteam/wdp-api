# frozen_string_literal: true

RSpec.describe Harvesting::UpsertEntityAssetsJob, type: :job do
  let(:harvest_entity) { FactoryBot.create :harvest_entity }

  it_behaves_like "a pass-through operation job", "harvesting.actions.upsert_entity_assets" do
    let(:job_arg) { harvest_entity }
  end
end
