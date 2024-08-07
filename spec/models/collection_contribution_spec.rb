# frozen_string_literal: true

RSpec.describe CollectionContribution, type: :model do
  let!(:contributor) { FactoryBot.create :contributor, :person }

  let!(:contribution) { FactoryBot.create :collection_contribution, contributor: }

  it_behaves_like "a contribution"
end
