# frozen_string_literal: true

RSpec.describe "Query.item.relatedItems", type: :request do
  let(:token) { token_helper.build_token }

  let!(:graphql_variables) { { slug: source_item.system_slug } }

  let!(:test_schema) { FactoryBot.create :schema_version, :item }
  let!(:other_schema) { FactoryBot.create :schema_version, :item }

  let!(:source_item) { FactoryBot.create :item, schema_version: test_schema }
  let!(:target_item) { FactoryBot.create :item, schema_version: test_schema }
  let!(:other_item) { FactoryBot.create :item, schema_version: other_schema }

  let!(:query) do
    <<~GRAPHQL
    query getRelatedItems($slug: Slug!) {
      item(slug: $slug) {
        relatedItems {
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
      item: {
        related_items: {
          edges: [
            { node: { id: target_item.to_encoded_id } }
          ],

          page_info: { total_count: 1 },
        },
      },
    }
  end

  before do
    FactoryBot.create :entity_link, source: source_item, target: target_item
    FactoryBot.create :entity_link, source: source_item, target: other_item
  end

  it "returns the right results" do
    expect do
      make_default_request!
    end.to execute_safely

    expect_graphql_response_data expected_shape, decamelize: true
  end
end
