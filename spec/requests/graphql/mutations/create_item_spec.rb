# frozen_string_literal: true

RSpec.describe Mutations::CreateItem, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:title) { Faker::Lorem.sentence }
    let!(:subtitle) { Faker::Lorem.sentence }
    let!(:community) { FactoryBot.create :community }
    let!(:visibility) { "VISIBLE" }
    let!(:thumbnail) do
      graphql_upload_from "spec", "data", "lorempixel.jpg"
    end
    let!(:summary) { "A test summary" }
    let!(:published) do
      {
        value: "2021-10-31",
        precision: "DAY",
      }
    end

    let!(:collection) { FactoryBot.create :collection, community: community }

    let!(:parent_item) { FactoryBot.create :item, collection: collection }

    let!(:parent) { collection }

    let!(:mutation_input) do
      {
        parentId: parent.to_encoded_id,
        title: title,
        subtitle: subtitle,
        published: published,
        visibility: visibility,
        thumbnail: thumbnail,
        summary: summary,
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
            subtitle: subtitle,
            published: published,
            visibility: visibility,
            summary: summary,
            parent: { id: parent.to_encoded_id },
            collection: { id: collection.to_encoded_id },
            community: { id: community.to_encoded_id },
          },
          attributeErrors: be_blank,
          globalErrors: be_blank,
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation createItem($input: CreateItemInput!) {
        createItem(input: $input) {
          item {
            title
            subtitle
            published {
              value
              precision
            }
            visibility
            summary
            community { id }
            collection { id }

            parent {
              ... on Node { id }
            }
          }

          attributeErrors {
            messages
            path
            type
          }

          globalErrors {
            message
          }
        }
      }
      GRAPHQL
    end

    context "with a blank title" do
      let(:title) { "" }

      let(:expected_shape) do
        {
          createItem: {
            item: be_blank,
            attributeErrors: [
              {
                path: "title",
                messages: [
                  I18n.t("dry_validation.errors.filled?")
                ]
              }
            ],
            globalErrors: be_blank,
          }
        }
      end

      it "fails" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Item, :count)

        expect_graphql_response_data expected_shape
      end
    end

    context "with an empty string for the summary" do
      let(:summary) { "" }

      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Item, :count).by(1)

        expect_graphql_response_data expected_shape
      end
    end

    context "with a null value for the summary" do
      let(:summary) { nil }

      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Item, :count).by(1)

        expect_graphql_response_data expected_shape
      end
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
