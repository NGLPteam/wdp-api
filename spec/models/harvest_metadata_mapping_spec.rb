# frozen_string_literal: true

RSpec.describe HarvestMetadataMapping, type: :model do
  let_it_be(:community, refind: true) { FactoryBot.create :community }
  let_it_be(:collection, refind: true) { FactoryBot.create :collection, community:, identifier: "some-collection" }
  let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, use_metadata_mappings: true }

  before do
    harvest_source.assign_metadata_mapping! field: :relation, pattern: "^ispartof:[[:space:]]+Water Resources Investigation Report.*", target_entity: collection
  end

  describe ".matching" do
    let_it_be(:needle) { "ispartof: Water Resources Investigation Report (Iowa Geological Survey) vol 17" }

    it "finds a matching value with no issue" do
      expect(described_class.matching(relation: needle)).to have(1).items
    end

    it "looks in the right fields" do
      expect(described_class.matching(title: needle)).to be_blank
    end

    it "finds no matching values as expected" do
      expect(described_class.matching).to be_blank
    end
  end
end
