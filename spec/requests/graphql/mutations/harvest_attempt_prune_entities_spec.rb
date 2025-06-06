# frozen_string_literal: true

RSpec.describe Mutations::HarvestAttemptPruneEntities, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestAttemptPruneEntities($input: HarvestAttemptPruneEntitiesInput!) {
    harvestAttemptPruneEntities(input: $input) {
      harvestAttempt {
        id
        slug
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:harvest_attempt_attrs) do
    {}
  end

  let_it_be(:harvest_attempt) { FactoryBot.create(:harvest_attempt, **harvest_attempt_attrs) }

  let_mutation_input!(:harvest_attempt_id) { harvest_attempt.to_encoded_id }
  let_mutation_input!(:mode) { "EVERYTHING" }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_attempt_prune_entities) do |m|
      m.prop(:harvest_attempt) do |ha|
        ha[:id] = be_an_encoded_id.of_an_existing_model
        ha[:slug] = be_an_encoded_slug
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_attempt_prune_entities
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "enqueues a job" do
      expect_request! do |req|
        req.effect! have_enqueued_job(Harvesting::Attempts::PruneEntitiesJob).once.with(harvest_attempt, mode: "everything")

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
