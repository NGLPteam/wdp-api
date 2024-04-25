# frozen_string_literal: true

RSpec.describe Mutations::DestroyItem, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation destroyItem($input: DestroyItemInput!) {
    destroyItem(input: $input) {
      destroyed
      destroyedId

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:item, refind: true) { FactoryBot.create :item }

  let_mutation_input!(:item_id) { item.to_encoded_id }

  as_an_admin_user do
    let(:expected_shape) do
      gql.mutation :destroy_item do |m|
        m[:destroyed] = true
      end
    end

    it "destroys the item" do
      expect_request! do |req|
        req.effect! change(Item, :count).by(-1)

        req.data! expected_shape
      end
    end

    context "when the item has at least one subitem" do
      let_it_be(:subitem, refind: true) { FactoryBot.create :item, parent: item }

      let(:expected_shape) do
        gql.mutation(:destroy_item, no_errors: false) do |m|
          m[:destroyed] = be_blank

          m.global_errors do |ge|
            ge.error :destroy_item_with_subitems
          end
        end
      end

      it "fails to destroy the item" do
        expect_request! do |req|
          req.effect! keep_the_same(Item, :count)

          req.data! expected_shape
        end
      end
    end
  end
end
