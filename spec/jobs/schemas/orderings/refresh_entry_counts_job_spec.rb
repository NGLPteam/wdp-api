# frozen_string_literal: true

RSpec.describe Schemas::Orderings::RefreshEntryCountsJob, type: :job, simple_v1_hierarchy: true do
  let!(:collection) { create_v1_collection }

  it "runs without issue" do
    expect do
      described_class.perform_now
    end.to execute_safely

    expect do
      create_v1_item(collection:)

      described_class.perform_now
    end.to change(OrderingEntryCount, :count).by(2)
  end
end
