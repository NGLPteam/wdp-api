# frozen_string_literal: true

RSpec.describe Schemas::Orderings::RefreshEntryCountsJob, type: :job, simple_v1_hierarchy: true do
  let!(:collection) { create_v1_collection }

  it "runs without issue" do
    expect do
      create_v1_item

      described_class.perform_now
    end.to execute_safely.and change(OrderingEntryCount, :count).by(1)
  end
end
