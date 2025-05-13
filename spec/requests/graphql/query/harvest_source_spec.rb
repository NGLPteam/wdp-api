# frozen_string_literal: true

RSpec.describe "Query.harvestSource", type: :request do
  let(:query) do
    <<~GRAPHQL
    query getHarvestSource($slug: Slug!) {
      harvestSource(slug: $slug) {
        id
        slug

        harvestAttempts {
          nodes {
            id
          }
        }

        harvestMappings {
          nodes {
            id
          }
        }

        harvestMetadataMappings {
          nodes {
            id
          }
        }
      }
    }
    GRAPHQL
  end

  let(:found_shape) do
    gql.query do |q|
      q.prop :harvest_source do |m|
        m[:id] = be_an_encoded_id.of_an_existing_model
        m[:slug] = be_an_encoded_slug
      end
    end
  end

  let(:blank_shape) do
    gql.query do |q|
      q[:harvest_source] = be_blank
    end
  end

  let_it_be(:harvest_source) { FactoryBot.create :harvest_source }

  let_it_be(:harvest_mapping) { FactoryBot.create :harvest_mapping, harvest_source: }
  let_it_be(:harvest_attempt) { FactoryBot.create :harvest_attempt, harvest_source:, harvest_mapping: }
  let_it_be(:harvest_metadata_mapping) { FactoryBot.create :harvest_metadata_mapping, harvest_source: }

  let!(:existing_model) { harvest_source }

  let(:slug) { existing_model.system_slug }

  let(:graphql_variables) do
    { slug:, }
  end

  shared_examples "a found record" do
    it "finds the HarvestSource" do
      expect_request! do |req|
        req.data! found_shape
      end
    end
  end

  shared_examples "a not found record" do
    it "does not find the HarvestSource" do
      expect_request! do |req|
        req.data! blank_shape
      end
    end
  end

  as_an_admin_user do
    context "when looking for an existing model" do
      include_examples "a found record"
    end

    context "when looking for an unknown model" do
      let(:slug) { random_slug }

      include_examples "a not found record"
    end
  end

  as_a_regular_user do
    context "when looking for an existing model" do
      include_examples "a not found record"
    end

    context "when looking for an unknown model" do
      let(:slug) { random_slug }

      include_examples "a not found record"
    end
  end

  as_an_anonymous_user do
    context "when looking for an existing model" do
      include_examples "a not found record"
    end

    context "when looking for an unknown model" do
      let(:slug) { random_slug }

      include_examples "a not found record"
    end
  end
end
