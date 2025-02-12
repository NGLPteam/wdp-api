# frozen_string_literal: true

RSpec.describe Mutations::HarvestMappingDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestMappingDestroy($input: HarvestMappingDestroyInput!) {
    harvestMappingDestroy(input: $input) {
      destroyed
      destroyedId
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
    gql.mutation(:harvest_mapping_destroy) do |m|
      m[:destroyed] = true
      m[:destroyed_id] = be_an_encoded_id.of_a_deleted_model
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_mapping_destroy
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "destroys the harvest mapping" do
      expect_request! do |req|
        req.effect! change(HarvestMapping, :count).by(-1)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely
        req.effect! keep_the_same(HarvestMapping, :count)

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
