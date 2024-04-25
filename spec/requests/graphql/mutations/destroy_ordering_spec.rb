# frozen_string_literal: true

RSpec.describe Mutations::DestroyOrdering, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation destroyOrdering($input: DestroyOrderingInput!) {
    destroyOrdering(input: $input) {
      disabled
      destroyed

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

    let(:was_disabled) { false }
    let(:was_destroyed) { false }

    let!(:expected_shape) do
      gql.mutation(:destroy_ordering) do |m|
        m[:disabled] = was_disabled
        m[:destroyed] = was_destroyed
      end
    end

    context "with an inherited ordering" do
      let(:was_disabled) { true }

      it "disables the ordering" do
        expect_the_default_request.to keep_the_same(Ordering, :count).and change { ordering.reload.disabled? }.from(false).to(true)

        expect_graphql_data expected_shape
      end
    end

    context "with a custom ordering" do
      let!(:ordering) { FactoryBot.create :ordering, entity: collection, schema_version: collection.schema_version }

      let(:was_destroyed) { true }

      it "destroys the ordering" do
        expect_the_default_request.to change(Ordering, :count).by(-1)

        expect_graphql_data expected_shape
      end
    end
  end
end
