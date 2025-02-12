# frozen_string_literal: true

RSpec.describe Mutations::HarvestSourceDestroy, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation HarvestSourceDestroy($input: HarvestSourceDestroyInput!) {
    harvestSourceDestroy(input: $input) {
      destroyed
      destroyedId
      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_harvest_source_attrs) do
    {}
  end

  let_it_be(:existing_harvest_source) { FactoryBot.create(:harvest_source, **existing_harvest_source_attrs) }

  let_mutation_input!(:harvest_source_id) { existing_harvest_source.to_encoded_id }

  let(:valid_mutation_shape) do
    gql.mutation(:harvest_source_destroy) do |m|
      m[:destroyed] = true
      m[:destroyed_id] = be_an_encoded_id.of_a_deleted_model
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :harvest_source_destroy
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "destroys the harvest source" do
      expect_request! do |req|
        req.effect! change(HarvestSource, :count).by(-1)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely
        req.effect! keep_the_same(HarvestSource, :count)

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
