# frozen_string_literal: true

RSpec.describe "Query.collection", type: :request, disable_ordering_refresh: true do
  let(:token) { token_helper.build_token has_global_admin: true }

  let!(:graphql_variables) { {} }

  let!(:journal) { FactoryBot.create :collection, schema: "nglp:journal" }

  let!(:volume) { FactoryBot.create :collection, parent: journal, schema: "nglp:journal_volume" }

  let!(:issue) { FactoryBot.create :collection, parent: volume, schema: "nglp:journal_issue" }

  let!(:article) { FactoryBot.create :item, collection: issue, schema: "nglp:journal_article" }

  before do
    perform_enqueued_jobs
  end

  context "when fetching ancestors and children of a specific type" do
    let!(:graphql_variables) { { slug: issue.system_slug } }

    let!(:other_item) { FactoryBot.create :item, collection: issue, schema: "default:item" }

    let!(:query) do
      <<~GRAPHQL
        query getCollection($slug: Slug!) {
          issue: collection(slug: $slug) {
            id

            journal: ancestorOfType(schema: "nglp:journal") {
              ... on Node { id }
            }

            volume: ancestorOfType(schema: "nglp:journal_volume") {
              ... on Node { id }
            }

            unknown: ancestorOfType(schema: "does_not:exist") {
              ... on Node { id }
            }

            articles: items(schema: "nglp:journal_article") {
              edges {
                node {
                  id
                }
              }

              pageInfo {
                totalCount
              }
            }

            items {
              pageInfo { totalCount }
            }
          }
        }
      GRAPHQL
    end

    let!(:expected_shape) do
      {
        issue: {
          id: issue.to_encoded_id,
          journal: {
            id: journal.to_encoded_id,
          },
          volume: {
            id: volume.to_encoded_id,
          },
          unknown: nil,
          articles: {
            edges: [{ node: { id: article.to_encoded_id } }],
            page_info: { total_count: 1 },
          },
          items: { page_info: { total_count: 2 } },
        }
      }
    end

    it "finds the right relatives" do
      expect_the_default_request.to execute_safely

      expect_graphql_data expected_shape
    end
  end

  describe "schemaRanks" do
    let!(:graphql_variables) { { slug: journal.system_slug } }

    let!(:query) do
      <<~GRAPHQL
      query getSchemaRanks($slug: Slug!) {
        journal: collection(slug: $slug) {
          schemaRanks {
            slug
            kind
            count
          }
        }
      }
      GRAPHQL
    end

    let!(:expected_shape) do
      {
        journal: {
          schema_ranks: [
            { slug: "nglp:journal_volume", kind: "COLLECTION", count: 1 },
            { slug: "nglp:journal_issue", kind: "COLLECTION", count: 1 },
            { slug: "nglp:journal_article", kind: "ITEM", count: 1 },
          ]
        }
      }
    end

    it "calculates the right ranks" do
      expect_the_default_request.to execute_safely

      expect_graphql_data expected_shape
    end
  end
end
