# frozen_string_literal: true

RSpec.describe Mutations::ResetOrdering, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation resetOrdering($input: ResetOrderingInput!) {
    resetOrdering(input: $input) {
      ordering { id }

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:schema_version) { FactoryBot.create :schema_version, :simple_collection }

    let!(:collection) { FactoryBot.create(:collection, schema_version:) }

    let!(:ordering) { collection.ordering!("items") }

    let_mutation_input!(:ordering_id) { ordering.to_encoded_id }

    let!(:expected_shape) do
      gql.mutation :reset_ordering do |m|
        m.prop :ordering do |o|
          o[:id] = ordering_id
        end
      end
    end

    context "with an inherited ordering" do
      it "resets the ordering" do
        expect_the_default_request.to keep_the_same(Ordering, :count)

        expect_graphql_data expected_shape
      end
    end

    context "with a custom ordering" do
      let!(:ordering) { FactoryBot.create :ordering, entity: collection, schema_version: collection.schema_version }

      it "resets the ordering" do
        expect_the_default_request.to keep_the_same(Ordering, :count)

        expect_graphql_data expected_shape
      end
    end
  end
end
