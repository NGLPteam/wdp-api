# frozen_string_literal: true

RSpec.describe Entities::FindGlobalCollections, type: :operation, disable_ordering_refresh: true do
  let_it_be(:community_a) { FactoryBot.create :community, title: "Community A" }
  let_it_be(:community_b) { FactoryBot.create :community, title: "Community B" }

  let_it_be(:collection_a1) { FactoryBot.create :collection, community: community_a }
  let_it_be(:collection_a2) { FactoryBot.create :collection, community: community_a }
  let_it_be(:collection_b1) { FactoryBot.create :collection, community: community_b }

  let_it_be(:collection_a11) { FactoryBot.create :collection, parent: collection_a1 }

  let_it_be(:item_a111) { FactoryBot.create :item, collection: collection_a11 }

  it "works with an item", :aggregate_failures do
    expect_calling_with(item_a111).to include(collection_a1, collection_a2, collection_a11)
    expect_calling_with(item_a111).to exclude(collection_b1)
  end

  it "works with a collection", :aggregate_failures do
    expect_calling_with(collection_a11).to include(collection_a1, collection_a2, collection_a11)
    expect_calling_with(collection_a11).to exclude(collection_b1)
  end

  it "works with a community", :aggregate_failures do
    expect_calling_with(community_a).to include(collection_a1, collection_a2, collection_a11)
    expect_calling_with(community_a).to exclude(collection_b1)
  end

  it "returns a null scope with an invalid object" do
    expect_calling_with(double(:invalid_object)).to be_blank
  end
end
