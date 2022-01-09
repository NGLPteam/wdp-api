# frozen_string_literal: true

RSpec.describe Entities::PopulateMissingOrderingsJob, type: :job, simple_v1_hierarchy: true do
  let(:operation) { instance_double(Schemas::Instances::PopulateOrderings, call: operation_result) }

  let(:operation_result) do
    Dry::Monads.Success()
  end

  context "when there are missing orderings" do
    let!(:collection) { create_v1_collection }

    before do
      Ordering.destroy_all
    end

    it "calls the operation on the expected record(s)" do
      expect do
        WDPAPI::Container.stub("schemas.instances.populate_orderings", operation) do
          described_class.perform_now
        end
      end.to execute_safely

      expect(operation).to have_received(:call).with(collection.community).once
      expect(operation).to have_received(:call).with(collection).once
    end
  end
end
