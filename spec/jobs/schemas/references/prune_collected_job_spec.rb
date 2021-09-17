# frozen_string_literal: true

RSpec.describe Schemas::References::PruneCollectedJob, type: :job do
  let!(:reference_1) { FactoryBot.create :schematic_collected_reference, :from_item, :to_contributor }
  let!(:reference_2) { FactoryBot.create :schematic_collected_reference, :from_item, :to_contributor }

  context "when a referent has been deleted" do
    before do
      # Delete a contributor without running lifecycle methods
      Contributor.where(id: reference_2.referent_id).delete_all
    end

    it "prunes the minimal amount" do
      expect do
        described_class.perform_now
      end.to change(SchematicCollectedReference, :count).by(-1)
    end
  end

  context "when all referents are present" do
    it "does nothing" do
      expect do
        described_class.perform_now
      end.to keep_the_same(SchematicCollectedReference, :count)
    end
  end
end
