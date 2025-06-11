# frozen_string_literal: true

RSpec.describe Entities::Purge, type: :operation do
  let_it_be(:community, refind: true) { FactoryBot.create :community }
  let_it_be(:collection_1, refind: true) { FactoryBot.create :collection, community: }
  let_it_be(:collection_1_1, refind: true) { FactoryBot.create :collection, parent: collection_1, community: }
  let_it_be(:collection_2, refind: true) { FactoryBot.create :collection, community: }

  let_it_be(:item_1, refind: true) { FactoryBot.create :item, collection: collection_1 }
  let_it_be(:item_1_1, refind: true) { FactoryBot.create :item, collection: collection_1, parent: item_1 }

  let_it_be(:link, refind: true) { collection_2.link_to! item_1_1, operator: :references }

  it "can purge an entire hierarchy" do
    expect do
      expect_calling_with(community).to succeed
    end.to execute_safely
      .and change(Community, :count).by(-1)
      .and change(Collection, :count).by(-3)
      .and change(Item, :count).by(-2)
      .and change(EntityLink, :count).by(-1)
  end

  context "when purging only a section of the hierarchy" do
    it "purges links but not anything external to the tree" do
      expect do
        expect_calling_with(collection_2).to succeed
      end.to execute_safely
        .and keep_the_same(Community, :count)
        .and change(Collection, :count).by(-1)
        .and keep_the_same(Item, :count)
        .and change(EntityLink, :count).by(-1)
    end
  end

  context "when mode=:mark" do
    it "marks for purge instead of actually deleting anything" do
      expect do
        expect_calling_with(community, mode: :mark).to succeed
      end.to execute_safely
        .and keep_the_same(Community, :count)
        .and keep_the_same(Collection, :count)
        .and keep_the_same(Item, :count)
        .and keep_the_same(EntityLink, :count)
        .and change { community.reload.marked_for_purge }.from(false).to(true)
        .and change { collection_1.reload.marked_for_purge }.from(false).to(true)
        .and change { collection_1_1.reload.marked_for_purge }.from(false).to(true)
        .and change { collection_2.reload.marked_for_purge }.from(false).to(true)
        .and change { item_1.reload.marked_for_purge }.from(false).to(true)
        .and change { item_1_1.reload.marked_for_purge }.from(false).to(true)
    end
  end
end
