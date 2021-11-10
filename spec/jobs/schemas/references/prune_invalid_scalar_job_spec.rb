# frozen_string_literal: true

RSpec.describe Schemas::References::PruneInvalidScalarJob, type: :job do
  let!(:invalid_reference) { FactoryBot.create :schematic_scalar_reference, path: "does_not.exist" }

  it "removes the invalid reference" do
    expect do
      described_class.perform_now
    end.to change(SchematicScalarReference, :count).by(-1)
  end
end
