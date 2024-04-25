# frozen_string_literal: true

RSpec.describe Mutations::CreateItem, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
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

      ...ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:community) { FactoryBot.create :community }
    let!(:collection) { FactoryBot.create :collection, community: }

    let_mutation_input!(:title) { Faker::Lorem.sentence }
    let_mutation_input!(:subtitle) { Faker::Lorem.sentence }
    let_mutation_input!(:visibility) { "VISIBLE" }
    let_mutation_input!(:thumbnail) do
      graphql_upload_from "spec", "data", "lorempixel.jpg"
    end
    let_mutation_input!(:summary) { "A test summary" }
    let_mutation_input!(:published) do
      {
        value: "2021-10-31",
        precision: "DAY",
      }
    end
    let_mutation_input!(:parent_id) { parent.to_encoded_id }

    let!(:parent_item) { FactoryBot.create :item, collection: }

    let!(:parent) { collection }

    let!(:expected_shape) do
      gql.mutation :create_item do |m|
        m.prop :item do |itm|
          itm[:title] = title
          itm[:subtitle] = subtitle
          itm[:published] = published
          itm[:visibility] = visibility
          itm[:summary] = summary

          itm.prop :parent do |p|
            p[:id] = parent_id
          end

          itm.prop :collection do |col|
            col[:id] = collection.to_encoded_id
          end

          itm.prop :community do |com|
            com[:id] = community.to_encoded_id
          end
        end
      end
    end

    context "with a blank title" do
      let_mutation_input!(:title) { "" }

      let(:expected_shape) do
        gql.mutation :create_item, no_errors: false do |m|
          m[:item] = be_blank

          m.errors do |e|
            e.error :title, :filled?
          end
        end
      end

      it "fails" do
        expect_the_default_request.to keep_the_same Item, :count

        expect_graphql_data expected_shape
      end
    end

    context "with an empty string for the summary" do
      let_mutation_input!(:summary) { "" }

      it "works" do
        expect_the_default_request.to change(Item, :count).by(1)

        expect_graphql_data expected_shape
      end
    end

    context "with a null value for the summary" do
      let_mutation_input!(:summary) { nil }

      it "works" do
        expect_the_default_request.to change(Item, :count).by(1)

        expect_graphql_data expected_shape
      end
    end

    context "with a collection as a parent" do
      let(:parent) { collection }

      it "works" do
        expect_the_default_request.to change(Item, :count).by(1)

        expect_graphql_data expected_shape
      end
    end

    context "with an item as a parent" do
      let(:parent) { parent_item }

      it "works" do
        expect_the_default_request.to change(Item, :count).by(1)

        expect_graphql_data expected_shape
      end
    end
  end
end
