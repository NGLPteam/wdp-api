# frozen_string_literal: true

RSpec.describe Mutations::CreateItem, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:title) { Faker::Lorem.sentence }
    let!(:identifier) { Faker::Lorem.word }
    let!(:community) { FactoryBot.create :community }

    let!(:collection) { FactoryBot.create :collection, community: community }

    let!(:parent_item) { FactoryBot.create :item, collection: collection }

    let!(:parent) { collection }

    let!(:mutation_input) do
      {
        parentId: parent.to_encoded_id,
        title: title,
        identifier: identifier,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        createItem: {
          item: {
            title: title,
            identifier: identifier,
            parent: { id: parent.to_encoded_id },
            collection: { id: collection.to_encoded_id },
            community: { id: community.to_encoded_id },
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation createItem($input: CreateItemInput!) {
        createItem(input: $input) {
          item {
            title
            identifier
            community { id }
            collection { id }

            parent {
              ... on Node { id }
            }
          }
        }
      }
      GRAPHQL
    end

    context "with a collection as a parent" do
      let(:parent) { collection }

      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Item, :count).by(1)

        expect_graphql_response_data expected_shape
      end
    end

    context "with an item as a parent" do
      let(:parent) { parent_item }

      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Item, :count).by(1)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
