# frozen_string_literal: true

RSpec.describe Entities::InvalidateAncestorLayoutsJob, type: :job do
  let_it_be(:community, refind: true) { FactoryBot.create :community }
  let_it_be(:collection, refind: true) { FactoryBot.create(:collection, community:) }
  let_it_be(:subcollection, refind: true) { FactoryBot.create(:collection, parent: collection, community:) }
  let_it_be(:item, refind: true) { FactoryBot.create(:item, collection:) }
  let_it_be(:descendant_item, refind: true) { FactoryBot.create(:item, collection: subcollection) }

  it "invalidates layouts for the right ancestors" do
    expect do
      described_class.perform_now descendant_item
    end.to change(LayoutInvalidation, :count).by(3)
      .and change(LayoutInvalidation.where(entity: subcollection), :count).by(1)
      .and change(LayoutInvalidation.where(entity: collection), :count).by(1)
      .and change(LayoutInvalidation.where(entity: community), :count).by(1)
  end

  it "works with a community (which produces no ancestors)" do
    expect do
      described_class.perform_now community
    end.to keep_the_same(LayoutInvalidation, :count)
  end
end
