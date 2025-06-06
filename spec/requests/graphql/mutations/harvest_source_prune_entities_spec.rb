# frozen_string_literal: true

RSpec.describe Mutations::HarvestSourcePruneEntities, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestSourcePruneEntities($input: HarvestSourcePruneEntitiesInput!) {
    harvestSourcePruneEntities(input: $input) {
      harvestSource {
        id
        slug
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:harvest_source_attrs) do
    {}
  end

  let_it_be(:harvest_source) { FactoryBot.create(:harvest_source, **harvest_source_attrs) }

  let_mutation_input!(:harvest_source_id) { harvest_source.to_encoded_id }
  let_mutation_input!(:mode) { "UNMODIFIED" }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_source_prune_entities) do |m|
      m.prop(:harvest_source) do |hs|
        hs[:id] = be_an_encoded_id.of_an_existing_model
        hs[:slug] = be_an_encoded_slug
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_source_prune_entities
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "enqueues a job" do
      expect_request! do |req|
        req.effect! have_enqueued_job(Harvesting::Sources::PruneEntitiesJob).once.with(harvest_source, mode: "unmodified")

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
