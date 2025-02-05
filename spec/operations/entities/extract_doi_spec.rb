# frozen_string_literal: true

RSpec.describe Entities::ExtractDOI, type: :operation do
  let_it_be(:doi) { "10.1080/10509585.2015.1092083" }
  let_it_be(:url) { "https://doi.org/10.1080/10509585.2015.1092083" }
  let_it_be(:collection_with_doi) { FactoryBot.create :collection, doi: }
  let_it_be(:collection_sans_doi) { FactoryBot.create :collection, doi: nil }

  it "works with a DOI value" do
    expect_calling_with(doi).to succeed.with(a_kind_of(Entities::DOIReference).and(have_attributes(doi:, url:)))
  end

  it "works with a DOI url" do
    expect_calling_with(url).to succeed.with(a_kind_of(Entities::DOIReference).and(have_attributes(doi:, url:)))
  end

  it "works with an entity that has a valid DOI" do
    expect_calling_with(collection_with_doi).to succeed.with(a_kind_of(Entities::DOIReference).and(have_attributes(doi:, url:)))
  end

  it "fails with an entity that lacks a valid DOI" do
    expect_calling_with(collection_sans_doi).to monad_fail.with_key(:invalid_doi)
  end
end
