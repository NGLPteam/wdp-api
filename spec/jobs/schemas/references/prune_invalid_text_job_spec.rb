# frozen_string_literal: true

RSpec.describe Schemas::References::PruneInvalidTextJob, type: :job do
  let!(:invalid_text) { FactoryBot.create :schematic_text, path: "does_not.exist" }

  it "removes the invalid text" do
    expect do
      described_class.perform_now
    end.to change(SchematicText, :count).by(-1)
  end
end
