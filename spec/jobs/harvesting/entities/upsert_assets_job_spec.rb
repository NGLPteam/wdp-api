# frozen_string_literal: true

RSpec.describe Harvesting::Entities::UpsertAssetsJob, type: :job do
  let(:harvest_entity) { FactoryBot.create :harvest_entity }

  it_behaves_like "a pass-through operation job", "harvesting.entities.upsert_assets" do
    let(:job_arg) { harvest_entity }
  end
end
