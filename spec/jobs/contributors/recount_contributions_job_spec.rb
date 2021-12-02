# frozen_string_literal: true

RSpec.describe Contributors::RecountContributionsJob, type: :job do
  let!(:contributor) { FactoryBot.create :contributor, :person }
  let!(:collection_contributions) { FactoryBot.create_list :collection_contribution, 2, contributor: contributor }
  let!(:item_contributions) { FactoryBot.create_list :item_contribution, 2, contributor: contributor }

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
