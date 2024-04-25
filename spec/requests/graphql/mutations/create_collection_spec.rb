# frozen_string_literal: true

RSpec.describe Mutations::CreateCollection, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
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

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:community) { FactoryBot.create :community }
    let!(:parent_collection) { FactoryBot.create :collection, community: }
    let!(:parent) { community }

    let(:alt_text) { "Some Alt Text" }

    let_mutation_input!(:parent_id) { parent.to_encoded_id }
    let_mutation_input!(:title) { Faker::Lorem.sentence }
    let_mutation_input!(:visibility) { "VISIBLE" }
    let_mutation_input!(:thumbnail) do
      graphql_upload_from "spec", "data", "lorempixel.jpg", alt: alt_text
    end

    let!(:expected_shape) do
      gql.mutation(:create_collection) do |m|
        m.prop :collection do |c|
          c[:title] = title
          c[:visibility] = visibility
          c.prop :parent do |p|
            p[:id] = parent_id
          end

          c.prop :community do |com|
            com[:id] = community.to_encoded_id
          end

          c.prop :thumbnail do |tn|
            tn[:alt] = alt_text
          end
        end
      end
    end

    context "with a community as a parent" do
      let(:parent) { community }

      it "works" do
        expect_the_default_request.to change(Collection, :count).by(1)

        expect_graphql_data expected_shape
      end

      context "when creating with a schema that defines orderings" do
        let!(:simple_community) { FactoryBot.create :schema_version, :simple_community }
        let!(:simple_collection) { FactoryBot.create :schema_version, :simple_collection }

        let!(:community) { FactoryBot.create :community, schema_version: simple_community }

        let_mutation_input!(:schema_version_slug) { simple_collection.declaration }

        it "creates the orderings" do
          expect_the_default_request.to change(Ordering, :count).by(2)

          expect_graphql_data expected_shape
        end
      end
    end

    context "with a collection as a parent" do
      let(:parent) { parent_collection }

      it "works" do
        expect_the_default_request.to change(Collection, :count).by(1)

        expect_graphql_data expected_shape
      end

      context "with a blank schema_version_slug" do
        let_mutation_input!(:schema_version_slug) { "" }

        let(:expected_shape) do
          gql.mutation(:create_collection, no_errors: false) do |m|
            m[:collection] = be_blank

            m.errors do |e|
              e.error :schema_version_slug, :filled?
            end
          end
        end

        it "fails" do
          expect_the_default_request.to keep_the_same(Collection, :count)

          expect_graphql_data expected_shape
        end
      end
    end
  end
end
