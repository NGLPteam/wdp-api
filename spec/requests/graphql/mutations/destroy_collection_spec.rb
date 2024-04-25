# frozen_string_literal: true

RSpec.describe Mutations::DestroyCollection, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation destroyCollection($input: DestroyCollectionInput!) {
    destroyCollection(input: $input) {
      destroyed
      destroyedId

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:collection, refind: true) { FactoryBot.create :collection }

  let_mutation_input!(:collection_id) { collection.to_encoded_id }

  as_an_admin_user do
    let!(:expected_shape) do
      gql.mutation :destroy_collection do |m|
        m[:destroyed] = true
        m[:destroyed_id] = eq(collection_id).and(be_an_encoded_id.of_a_deleted_model)
      end
    end

    it "destroys the collection" do
      expect_request! do |req|
        req.effect! change(Collection, :count).by(-1)

        req.data! expected_shape
      end
    end

    context "when the collection has at least one subcollection" do
      let_it_be(:subcollection, refind: true) { FactoryBot.create :collection, parent: collection }

      let(:expected_shape) do
        gql.mutation :destroy_collection, no_errors: false do |m|
          m[:destroyed] = be_blank
          m[:destroyed_id] = be_blank

          m.global_errors do |ge|
            ge.error :destroy_collection_with_subcollections
          end
        end
      end

      it "fails to destroy the collection" do
        expect_request! do |req|
          req.effect! keep_the_same Collection, :count

          req.data! expected_shape
        end
      end
    end

    context "when the collection has at least one item" do
      let_it_be(:item, refind: true) { FactoryBot.create :item, collection: }

      let(:expected_shape) do
        gql.mutation :destroy_collection, no_errors: false do |m|
          m[:destroyed] = be_blank
          m[:destroyed_id] = be_blank

          m.global_errors do |ge|
            ge.error :destroy_collection_with_items
          end
        end
      end

      it "fails to destroy the collection" do
        expect_request! do |req|
          req.effect! keep_the_same Collection, :count

          req.data! expected_shape
        end
      end
    end
  end
end
