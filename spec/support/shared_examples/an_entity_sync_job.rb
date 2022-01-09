# frozen_string_literal: true

RSpec.shared_examples_for "an entity sync job" do
  let(:entities) { [] }

  let(:entity_count) { entities.size }

  let(:sync_operation) { instance_double(Entities::Sync, call: sync_result) }

  let(:sync_result) { Dry::Monads.Success() }

  after do
    WDPAPI::Container.unstub "entities.sync"
  end

  it "synchronizes the expected amount of entities" do
    allow(sync_operation).to receive(:call).and_return(success)

    expect do
      WDPAPI::Container.stub "entities.sync", operation do
        described_class.perform_now
      end
    end.to execute_safely

    expect(operation).to have_received(:call).with(a_kind_of(entities.first.class)).exactly(entity_count).times
  end
end
