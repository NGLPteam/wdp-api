# frozen_string_literal: true

RSpec.describe Mutations::Contracts::CreateCollection, type: :operation do
  let!(:operation) { described_class.new }

  let!(:schema_version_slug) { "default:collection:latest" }

  let!(:doi) { "" }

  let!(:inputs) do
    {
      schema_version_slug: schema_version_slug,
      doi: doi
    }
  end

  it "is valid with good inputs" do
    expect_calling_with(inputs).to be_success
  end

  context "with an already existing DOI" do
    let!(:doi) { "existing" }

    let!(:collection) { FactoryBot.create :collection, doi: doi }

    it "is invalid" do
      expect_calling_with(inputs).to be_failure
    end
  end
end
