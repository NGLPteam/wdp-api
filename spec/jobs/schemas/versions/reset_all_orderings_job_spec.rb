# frozen_string_literal: true

RSpec.describe Schemas::Versions::ResetAllOrderingsJob, type: :job, simple_v1_hierarchy: true do
  let!(:collection_1) { create_v1_collection }
  let!(:collection_2) { create_v1_collection }

  it "enqueues reset jobs for each entity that implements the schema" do
    expect do
      described_class.perform_now simple_collection_v1
    end.to have_enqueued_job(Schemas::Instances::ResetAllOrderingsJob).at_least(2).times
  end
end
