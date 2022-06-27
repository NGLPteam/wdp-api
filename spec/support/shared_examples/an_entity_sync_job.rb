# frozen_string_literal: true

RSpec.shared_examples_for "an entity sync job", disable_ordering_refresh: true do
  include_context "sans entity sync"

  let(:entities) { [] }

  let(:entity_count) { entities.size }

  it "enqueues a sync job for the expected amount of entities" do
    expect do
      described_class.perform_now
    end.to have_enqueued_job(Entities::SynchronizeJob).exactly(entity_count).times
  end
end
