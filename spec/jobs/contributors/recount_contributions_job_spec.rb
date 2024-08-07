# frozen_string_literal: true

RSpec.describe Contributors::RecountContributionsJob, type: :job, disable_ordering_refresh: true do
  let!(:contributor) { FactoryBot.create :contributor, :person }
  let!(:collection_contributions) { FactoryBot.create_list :collection_contribution, 2, contributor: }
  let!(:item_contributions) { FactoryBot.create_list :item_contribution, 2, contributor: }

  before do
    CollectionContribution.where(contributor_id: contributor.id).delete_all
    ItemContribution.where(contributor_id: contributor.id).delete_all
  end

  it "recalculates the contribution counts" do
    expect do
      described_class.perform_now contributor
    end.to change { contributor.reload.item_contribution_count }.by(-2).
      and change { contributor.reload.collection_contribution_count }.by(-2).
      and change { contributor.reload.contribution_count }.by(-4)
  end
end
