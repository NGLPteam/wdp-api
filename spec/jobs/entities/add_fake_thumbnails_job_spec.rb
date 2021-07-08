# frozen_string_literal: true

RSpec.describe Entities::AddFakeThumbnailsJob, type: :job do
  let!(:community) { FactoryBot.create :community }
  let!(:collections) { FactoryBot.create_list :collection, 2, community: community }
  let!(:items) { FactoryBot.create_list :item, 3, collection: collections.first }

  it "enqueues a job for all entities" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job.exactly(6).times
  end
end
