# frozen_string_literal: true

RSpec.describe Entities::ReindexSearchJob, type: :job, simple_v1_hierarchy: true do
  let!(:item) { create_v1_item }

  it "enqueues the right number of jobs" do
    real_entity_count = Entity.real.count

    expect do
      described_class.perform_now
    end.to have_enqueued_job(Schemas::Instances::ReindexJob).exactly(real_entity_count).times
  end
end
