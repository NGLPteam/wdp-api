# frozen_string_literal: true

RSpec.describe Mutations::DestroyOrdering, type: :request do
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

    let(:was_disabled) { false }
    let(:was_destroyed) { false }

    let!(:expected_shape) do
      {
        destroyOrdering: {
          disabled: was_disabled,
          destroyed: was_destroyed,
          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation destroyOrdering($input: DestroyOrderingInput!) {
        destroyOrdering(input: $input) {
          disabled
          destroyed

          errors { message }
        }
      }
      GRAPHQL
    end

    context "with an inherited ordering" do
      let(:was_disabled) { true }

      it "disables the ordering" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Ordering, :count).and change { ordering.reload.disabled? }.from(false).to(true)

        expect_graphql_response_data expected_shape
      end
    end

    context "with a custom ordering" do
      let!(:ordering) { FactoryBot.create :ordering, entity: collection, schema_version: collection.schema_version }

      let(:was_destroyed) { true }

      it "destroys the ordering" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Ordering, :count).by(-1)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
