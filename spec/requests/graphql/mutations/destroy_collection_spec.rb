# frozen_string_literal: true

RSpec.describe Mutations::DestroyCollection, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:collection) { FactoryBot.create :collection }

    let!(:mutation_input) do
      {
        collectionId: collection.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        destroyCollection: {
          destroyed: true,
          destroyedId: a_kind_of(String),
          globalErrors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation destroyCollection($input: DestroyCollectionInput!) {
        destroyCollection(input: $input) {
          destroyed
          destroyedId

          globalErrors { message }
        }
      }
      GRAPHQL
    end

    it "destroys the collection" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(Collection, :count).by(-1)

      expect_graphql_response_data expected_shape

      expect(
        graphql_response(
          :data, :destroy_collection, :destroyed_id,
          decamelize: true
        )
      ).to be_an_encoded_id.of_a_deleted_model
    end

    context "when the collection has at least one subcollection" do
      let!(:subcollection) { FactoryBot.create :collection, parent: collection }

      let(:expected_shape) do
        {
          destroyCollection: {
            destroyed: be_blank,
            destroyedId: be_blank,
            globalErrors: [
              { message: I18n.t("dry_validation.errors.destroy_collection_with_subcollections") }
            ]
          }
        }
      end

      it "fails to destroy the collection" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Collection, :count)

        expect_graphql_response_data expected_shape
      end
    end

    context "when the collection has at least one item" do
      let!(:item) { FactoryBot.create :item, collection: collection }

      let(:expected_shape) do
        {
          destroyCollection: {
            destroyed: be_blank,
            destroyedId: be_blank,
            globalErrors: [
              { message: I18n.t("dry_validation.errors.destroy_collection_with_items") }
            ]
          }
        }
      end

      it "fails to destroy the collection" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Collection, :count)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
