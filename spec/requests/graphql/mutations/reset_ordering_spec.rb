# frozen_string_literal: true

RSpec.describe Mutations::ResetOrdering, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:schema_version) { SchemaVersion["nglp:journal"] }

    let!(:collection) { FactoryBot.create(:collection, schema_version: schema_version) }

    let!(:ordering) do
      collection.populate_orderings!.value!

      collection.orderings.by_identifier("everything").first!
    end

    let!(:mutation_input) do
      {
        orderingId: ordering.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        resetOrdering: {
          ordering: { id: be_present },
          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation resetOrdering($input: ResetOrderingInput!) {
        resetOrdering(input: $input) {
          ordering { id }

          errors { message }
        }
      }
      GRAPHQL
    end

    context "with an inherited ordering" do
      it "resets the ordering" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Ordering, :count)

        expect_graphql_response_data expected_shape
      end
    end

    context "with a custom ordering" do
      let!(:ordering) { FactoryBot.create :ordering, entity: collection, schema_version: collection.schema_version }

      it "resets the ordering" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Ordering, :count)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
