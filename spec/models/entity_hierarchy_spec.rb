# frozen_string_literal: true

RSpec.describe EntityHierarchy, type: :model do
  include ActiveJob::TestHelper

  let!(:community) { FactoryBot.create :community }

  it "is pruned by lifecycle methods" do
    collection = nil

    expect do
      perform_enqueued_jobs do
        collection = FactoryBot.create :collection, community: community
      end
    end.to change(described_class, :count).by_at_least(1)

    expect do
      collection.destroy!
    end.to change(described_class, :count).by_at_most(-1)
  end
end
