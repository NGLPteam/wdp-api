# frozen_string_literal: true

RSpec.describe Mutations::CreateCollection, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:title) { Faker::Lorem.sentence }
    let!(:community) { FactoryBot.create :community }
    let!(:visibility) { "VISIBLE" }
    let!(:alt_text) { "Some Alt Text" }
    let!(:thumbnail) do
      graphql_upload_from "spec", "data", "lorempixel.jpg", alt: alt_text
    end

    let!(:parent_collection) { FactoryBot.create :collection, community: community }

    let!(:parent) { community }

    let!(:mutation_input) do
      {
        parentId: parent.to_encoded_id,
        title: title,
        visibility: visibility,
        thumbnail: thumbnail,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        createCollection: {
          collection: {
            title: title,
            visibility: visibility,
            parent: { id: parent.to_encoded_id },
            community: { id: community.to_encoded_id },
            thumbnail: { alt: alt_text }
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation createCollection($input: CreateCollectionInput!) {
        createCollection(input: $input) {
          collection {
            title
            visibility
            community { id }

            thumbnail {
              alt
            }

            parent {
              ... on Node { id }
            }
          }
        }
      }
      GRAPHQL
    end

    context "with a community as a parent" do
      let(:parent) { community }

      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Collection, :count).by(1)

        expect_graphql_response_data expected_shape
      end
    end

    context "with a collection as a parent" do
      let(:parent) { parent_collection }

      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Collection, :count).by(1)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
