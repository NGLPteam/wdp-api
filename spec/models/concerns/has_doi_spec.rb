# frozen_string_literal: true

RSpec.describe HasDOI do
  let_it_be(:entity) { FactoryBot.create :collection }

  let_it_be(:doi) { "10.1080/10509585.2015.1092083" }
  let_it_be(:url) { "https://doi.org/10.1080/10509585.2015.1092083" }
  let_it_be(:other_host) { "doi.example.com" }
  let_it_be(:other_url) { "https://#{other_host}/#{doi}" }
  let_it_be(:bad_doi) { "HTTPS://DOI.ORG/junk-data" }

  describe "#doi=" do
    it "causes #doi to delegate to #raw_doi when the model has a pending change" do
      expect do
        entity.doi = bad_doi
      end.to change(entity, :doi).from(nil).to(bad_doi)
        .and change(entity, :raw_doi).from(nil).to(bad_doi)

      expect do
        entity.save!
      end.to execute_safely
        .and keep_the_same(entity, :raw_doi)
        .and change(entity, :doi).from(bad_doi).to(nil)
    end
  end
end
