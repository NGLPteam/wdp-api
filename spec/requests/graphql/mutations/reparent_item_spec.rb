# frozen_string_literal: true

RSpec.describe Mutations::ReparentItem, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:community) { FactoryBot.create :community }

    let!(:collection) { FactoryBot.create :collection, community: community }

    let!(:parent) { collection }

    let!(:new_parent) { FactoryBot.create :collection, community: community }

    let!(:item) { FactoryBot.create :item, collection: parent }

    let!(:mutation_input) do
      {
        itemId: item.to_encoded_id,
        parentId: new_parent.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        reparentItem: {
          item: {
            parent: { id: new_parent.to_encoded_id }
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation reparentItem($input: ReparentItemInput!) {
        reparentItem(input: $input) {
          item {
            parent {
              ... on Node { id }
            }
          }
        }
      }
      GRAPHQL
    end

    context "it can reparent to a new collection" do
      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to execute_safely

        expect_graphql_response_data expected_shape
      end
    end

    context "it can reparent to a new item" do
      let(:new_parent) { FactoryBot.create :item, collection: collection }

      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to execute_safely

        expect_graphql_response_data expected_shape
      end
    end
  end
end
