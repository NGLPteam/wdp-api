# frozen_string_literal: true

RSpec.describe EntityAncestor, type: :model do
  context "with a simple hierarchy tree" do
    let!(:community_schema) { FactoryBot.create :schema_version, :simple_community }
    let!(:collection_schema) { FactoryBot.create :schema_version, :simple_collection }
    let!(:item_schema) { FactoryBot.create :schema_version, :simple_item }

    let!(:community) { FactoryBot.create :community, schema: community_schema }
    let!(:collection) { FactoryBot.create :collection, schema: collection_schema, community: community }
    let!(:item) { FactoryBot.create :item, schema: item_schema, collection: collection }

    it "has the expected count of entity ancestors" do
      expect(item.named_ancestors.count).to eq 1
    end

    specify "an entity can fetch an ancestor by name" do
      expect(item.ancestor_by_name("community")).to eq community
    end
  end
end
