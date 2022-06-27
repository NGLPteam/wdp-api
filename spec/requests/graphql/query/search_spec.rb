# frozen_string_literal: true

RSpec.describe "Query.search", type: :request do
  let_it_be(:query) do
    <<~GRAPHQL
    query performSearch(
      $collectionSlug: Slug!,
      $maxDepth: Int,
      $predicates: [SearchPredicateInput!],
      $prefix: String,
      $query: String,
      $visibility: EntityVisibilityFilter
    ) {
      search(maxDepth: $maxDepth, visibility: $visibility) {
        ... SearchScopeFragment
      }

      collection(slug: $collectionSlug) {
        id

        search(maxDepth: $maxDepth, visibility: $visibility) {
          ... SearchScopeFragment
        }
      }
    }

    fragment SearchScopeFragment on SearchScope {
      availableSchemaVersions {
        id
        namespace
        identifier
        slug
      }

      originType

      visibility

      results(predicates: $predicates, prefix: $prefix, query: $query) {
        edges {
          node {
            entity { ... on Node { id } }
            kind
            id
            slug
            title
          }
        }

        pageInfo {
          totalCount
        }
      }
    }
    GRAPHQL
  end

  let_it_be(:community) { FactoryBot.create :community, title: "University of Testing" }
  let_it_be(:coll_1) { FactoryBot.create :collection, community: community, title: "Testable Collection" }
  let_it_be(:coll_2) { FactoryBot.create :collection, community: community, title: "Unknown Collection" }
  let_it_be(:item_1_1) { FactoryBot.create :item, collection: coll_1, title: "Some Item" }
  let_it_be(:item_2_1) { FactoryBot.create :item, collection: coll_2, title: "Known Item" }

  let(:collection_slug) { random_slug }
  let(:max_depth) { nil }
  let(:search_predicates) { [] }
  let(:search_prefix) { nil }
  let(:search_query) { nil }
  let(:search_visibility) { "VISIBLE" }

  let(:graphql_variables) do
    {
      collection_slug: collection_slug,
      max_depth: max_depth,
      predicates: search_predicates,
      prefix: search_prefix,
      query: search_query,
      visibility: search_visibility,
    }
  end

  let(:expected_global_entities) { [] }
  let(:expected_scoped_entities) { [] }
  let(:expected_scoped_collection) { nil }

  let(:expected_global_edges) do
    expected_global_entities.map do |entity|
      to_search_result(entity)
    end
  end

  let(:expected_scoped_edges) do
    expected_scoped_entities.map do |entity|
      to_search_result(entity)
    end
  end

  let(:expected_shape) do
    gql.query do |q|
      q.prop :search do |s|
        s[:origin_type] = "GLOBAL"
        s[:visibility] = search_visibility
        s.prop :results do |r|
          r[:edges] = expected_global_edges

          r.prop :page_info do |pi|
            pi[:total_count] = expected_global_entities.size
          end
        end
      end

      if expected_scoped_collection
        q.prop :collection do |c|
          c[:id] = expected_scoped_collection.to_encoded_id

          c.prop :search do |s|
            s[:origin_type] = "ENTITY"
            s[:visibility] = search_visibility

            s.prop :results do |r|
              r[:edges] = expected_scoped_edges

              r.prop :page_info do |pi|
                pi[:total_count] = expected_scoped_entities.size
              end
            end
          end
        end
      else
        q[:collection] = be_blank
      end
    end
  end

  def to_search_result(entity)
    node = {
      id: entity.to_encoded_id,
      kind: Types::EntityKindType.name_for_value(entity.entity_type),
      slug: be_present,
      title: entity.title,
    }

    { node: node, }
  end

  shared_examples_for "a valid search" do
    it "finds the expected entities" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  context "when searching by prefix" do
    let(:search_prefix) { "unknown c" }

    let(:expected_global_entities) { [coll_2] }

    include_examples "a valid search"

    context "when searching for an item" do
      let(:search_prefix) { "some i" }

      let(:expected_global_entities) { [item_1_1] }

      include_examples "a valid search"

      context "when scoped to the parent collection" do
        let(:collection_slug) { coll_1.system_slug }

        let(:expected_global_entities) { [] }
        let(:expected_scoped_collection) { coll_1 }
        let(:expected_scoped_entities) { [item_1_1] }

        let(:max_depth) { 2 }

        include_examples "a valid search"
      end

      context "when scoped to a different entity" do
        let(:collection_slug) { coll_2.system_slug }

        let(:expected_scoped_collection) { coll_2 }

        let(:expected_scoped_entities) { [] }

        include_examples "a valid search"
      end
    end
  end

  context "when searching by query" do
    let(:search_query) { "unknown" }

    let(:expected_global_entities) { [coll_2] }

    include_examples "a valid search"
  end
end
