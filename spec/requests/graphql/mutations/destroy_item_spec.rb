# frozen_string_literal: true

RSpec.describe Mutations::DestroyItem, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:item) { FactoryBot.create :item }

    let!(:mutation_input) do
      {
        itemId: item.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        destroyItem: {
          destroyed: true,
          globalErrors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation destroyItem($input: DestroyItemInput!) {
        destroyItem(input: $input) {
          destroyed

          globalErrors { message }
        }
      }
      GRAPHQL
    end

    it "destroys the item" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(Item, :count).by(-1)

      expect_graphql_response_data expected_shape
    end

    context "when the item has at least one subitem" do
      let!(:subitem) { FactoryBot.create :item, parent: item }

      let(:expected_shape) do
        {
          destroyItem: {
            destroyed: be_blank,
            globalErrors: [
              { message: I18n.t("dry_validation.errors.destroy_item_with_subitems") }
            ]
          }
        }
      end

      it "fails to destroy the item" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Item, :count)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
