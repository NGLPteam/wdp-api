# frozen_string_literal: true

RSpec.describe "Query.harvestSet", type: :request do
  let(:query) do
    <<~GRAPHQL
    query getHarvestSet($slug: Slug!) {
      harvestSet(slug: $slug) {
        id
        slug
        name
        identifier
        createdAt
        updatedAt

        harvestSource {
          slug
        }
      }
    }
    GRAPHQL
  end

  let_it_be(:existing_model) { FactoryBot.create :harvest_set }

  let(:found_shape) do
    gql.query do |q|
      q.prop :harvest_set do |m|
        m[:id] = be_an_encoded_id.of_an_existing_model
        m[:slug] = be_an_encoded_slug
      end
    end
  end

  let(:blank_shape) do
    gql.query do |q|
      q[:harvest_set] = be_blank
    end
  end

  let(:slug) { existing_model.system_slug }

  let(:graphql_variables) do
    { slug:, }
  end

  shared_examples "a found record" do
    it "finds the HarvestSet" do
      expect_request! do |req|
        req.data! found_shape
      end
    end
  end

  shared_examples "a not found record" do
    it "does not find the HarvestSet" do
      expect_request! do |req|
        req.data! blank_shape
      end
    end
  end

  as_a_regular_user do
    context "when looking for an existing model" do
      include_examples "a found record"
    end

    context "when looking for an unknown model" do
      let(:slug) { random_slug }

      include_examples "a not found record"
    end
  end

  as_an_anonymous_user do
    context "when looking for an existing model" do
      include_examples "a found record"
    end

    context "when looking for an unknown model" do
      let(:slug) { random_slug }

      include_examples "a not found record"
    end
  end
end
