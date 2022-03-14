# frozen_string_literal: true

RSpec.describe Mutations::ClearInitialOrdering, type: :request, graphql: :mutation, simple_v1_hierarchy: true do
  mutation_query! <<~GRAPHQL
  mutation clearInitialOrdering($input: ClearInitialOrderingInput!) {
    clearInitialOrdering(input: $input) {
      entity { ... on Node { id } }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let!(:collection) { create_v1_collection }

  let!(:item) { create_v1_item collection: collection }

  let!(:ordering) { collection.orderings.by_identifier("subcollections").first! }

  let_mutation_input!(:entity_id) { collection.to_encoded_id }

  let(:expected_shape) do
    gql.mutation(:clear_initial_ordering) do |m|
      m.prop(:entity) do |e|
        e[:id] = entity_id
      end
    end
  end

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "with no previous selection" do
      before do
        collection.clear_initial_ordering.value!
      end

      it "is idempotent" do
        expect_the_default_request.to keep_the_same(InitialOrderingSelection, :count)

        expect_graphql_data expected_shape
      end
    end

    context "with a previous selection" do
      before do
        collection.select_initial_ordering(ordering).value!
      end

      it "clears the selected ordering" do
        expect_the_default_request.to change(InitialOrderingSelection, :count).by(-1)

        expect_graphql_data expected_shape
      end
    end
  end
end
