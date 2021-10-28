# frozen_string_literal: true

RSpec.describe Mutations::Contracts::UpdateItem, type: :operation do
  let!(:operation) { described_class.new }

  let!(:current_doi) { "current-doi" }

  let!(:new_doi) { "new-doi" }

  let!(:item) { FactoryBot.create :item, doi: current_doi }

  let!(:inputs) do
    {
      item: item,
      doi: new_doi
    }
  end

  it "is valid with good inputs" do
    expect_calling_with(inputs).to be_success
  end

  context "with an already existing DOI" do
    let!(:existing_item) { FactoryBot.create :item, doi: new_doi }

    it "is invalid" do
      expect_calling_with(inputs).to be_failure
    end
  end

  context "with the same DOI as the updated record" do
    let!(:new_doi) { current_doi }

    it "is valid" do
      expect_calling_with(inputs).to be_success
    end
  end
end
