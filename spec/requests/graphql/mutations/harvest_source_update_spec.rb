# frozen_string_literal: true

RSpec.describe Mutations::HarvestSourceUpdate, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestSourceUpdate($input: HarvestSourceUpdateInput!) {
    harvestSourceUpdate(input: $input) {
      harvestSource {
        id
        slug
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_harvest_source_attrs) do
    {}
  end

  let_it_be(:existing_harvest_source) { FactoryBot.create(:harvest_source, **existing_harvest_source_attrs) }

  let_mutation_input!(:harvest_source_id) { existing_harvest_source.to_encoded_id }

  let_mutation_input!(:name) { "Test Harvest Source" }
  let_mutation_input!(:base_url) { "https://example.com/oai" }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_source_update) do |m|
      m.prop(:harvest_source) do |hs|
        hs[:id] = be_an_encoded_id.of_an_existing_model
        hs[:slug] = be_an_encoded_slug
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_source_update
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "updates the harvest source" do
      expect_request! do |req|
        req.effect! keep_the_same(HarvestSource, :count)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! expected_shape
      end
    end
  end

  as_an_admin_user do
    it_behaves_like "a successful mutation"
  end

  as_an_anonymous_user do
    it_behaves_like "an unauthorized mutation"
  end
end
