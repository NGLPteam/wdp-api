# frozen_string_literal: true

RSpec.describe "Query.collection.relatedCollections", type: :request do
  let(:token) { token_helper.build_token }

  let!(:graphql_variables) { { slug: source_collection.system_slug } }

  let!(:test_schema) { FactoryBot.create :schema_version, :collection }
  let!(:other_schema) { FactoryBot.create :schema_version, :collection }

  let!(:source_collection) { FactoryBot.create :collection, schema_version: test_schema }
  let!(:target_collection) { FactoryBot.create :collection, schema_version: test_schema }
  let!(:other_collection) { FactoryBot.create :collection, schema_version: other_schema }

  let!(:query) do
    <<~GRAPHQL
    query getRelatedCollections($slug: Slug!) {
      collection(slug: $slug) {
        relatedCollections {
          edges {
            node {
              id
            }
          }

          pageInfo { totalCount }
        }
      }
    }
    GRAPHQL
  end

  let!(:expected_shape) do
    {
      collection: {
        related_collections: {
          edges: [
            { node: { id: target_collection.to_encoded_id } }
          ],

          page_info: { total_count: 1 },
        },
      },
    }
  end

  before do
    FactoryBot.create :entity_link, source: source_collection, target: target_collection
    FactoryBot.create :entity_link, source: source_collection, target: other_collection
  end

  it "returns the right results" do
    expect_request! do |req|
      req.data! expected_shape
    end
  end
end
