# frozen_string_literal: true

RSpec.describe Schemas::Instances::ResetAllOrderingsJob, type: :job, simple_v1_hierarchy: true do
  let!(:collection) { create_v1_collection }

  let!(:populate_operation) { Schemas::Instances::PopulateOrderings.new }

  let!(:reset_operation) { Schemas::Orderings::Reset.new }

  around do |example|
    WDPAPI::Container.stub "schemas.instances.populate_orderings", populate_operation do
      WDPAPI::Container.stub "schemas.orderings.reset", reset_operation do
        example.run
      end
    end
  end

  it "populates and resets orderings as expected" do
    allow(populate_operation).to receive(:call).and_call_original
    allow(reset_operation).to receive(:call).and_call_original

    expect do
      described_class.perform_now collection
    end.to execute_safely

    expect(populate_operation).to have_received(:call).with(collection).once
    expect(reset_operation).to have_received(:call).with(a_kind_of(Ordering)).twice
  end
end
