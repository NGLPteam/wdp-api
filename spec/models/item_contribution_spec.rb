# frozen_string_literal: true

RSpec.describe ItemContribution, type: :model do
  let!(:contributor) { FactoryBot.create :contributor, :person }

  let!(:contribution) { FactoryBot.create :item_contribution, contributor: contributor }

  it_behaves_like "a contribution"
end
