# frozen_string_literal: true

RSpec.describe Mutations::HarvestAttemptFromMapping, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestAttemptFromMapping($input: HarvestAttemptFromMappingInput!) {
    harvestAttemptFromMapping(input: $input) {
      harvestAttempt {
        id
        slug
      }
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_harvest_mapping_attrs) do
    {}
  end

  let_it_be(:existing_harvest_mapping) { FactoryBot.create(:harvest_mapping, **existing_harvest_mapping_attrs) }

  let_mutation_input!(:harvest_mapping_id) { existing_harvest_mapping.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_attempt_from_mapping) do |m|
      m.prop(:harvest_attempt) do |hm|
        hm[:id] = be_an_encoded_id.of_an_existing_model
        hm[:slug] = be_an_encoded_slug
      end
    end
  end

  let(:not_yet_implemented_shape) do
    gql.mutation(:harvest_attempt_from_mapping, no_errors: false) do |m|
      m[:harvest_attempt] = be_blank

      m.global_errors do |ge|
        ge.error :not_yet_implemented
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_attempt_from_mapping
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { not_yet_implemented_shape }

    it "is not yet implemented" do
      expect_request! do |req|
        req.effect! keep_the_same(HarvestAttempt, :count)

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
