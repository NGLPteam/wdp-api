# frozen_string_literal: true

RSpec.describe "Page-Based Pagination", type: :request, disable_ordering_refresh: true do
  let_it_be(:test_schema) { FactoryBot.create :schema_version, :collection }

  let_it_be(:collection) { FactoryBot.create :collection }

  let_it_be(:special_collection) { FactoryBot.create :collection, title: ?D, parent: collection, schema_version: test_schema }

  let_it_be(:subcollections) do
    ?a.upto(?c).each_with_object({}) do |title, h|
      key = title.to_sym

      h[key] = FactoryBot.create :collection, title: title.upcase, parent: collection
    end.tap do |h|
      h[:d] = special_collection
    end
  end

  let!(:order) { "TITLE_ASCENDING" }
  let!(:page) { nil }
  let!(:per_page) { nil }
  let!(:page_direction) { "FORWARDS" }
  let!(:before) { nil }
  let!(:after) { nil }
  let!(:schema_filter) { nil }

  let!(:graphql_variables) do
    {
      slug: collection.system_slug,
      order:,
      page:,
      per_page:,
      page_direction:,
      before:,
      after:,
      schema: Array(schema_filter).presence,
    }.compact
  end

  let_it_be(:subcollection_count) { collection.children.count }

  let!(:derived_page) { page || 1 if page || per_page }
  let!(:derived_per_page) { per_page || Support::GraphQLAPI::Constants::DEFAULT_PER_PAGE_SIZE if page || per_page }

  let(:expected_page) { page }
  let(:expected_per_page) { per_page }
  let(:expected_page_count) { (subcollection_count.to_f / derived_per_page).ceil if derived_page && derived_per_page }
  let(:expected_total_count) { subcollection_count }
  let(:expected_total_unfiltered_count) { subcollection_count }

  let(:expected_page_info) do
    {
      page: expected_page,
      per_page: expected_per_page,
      page_count: expected_page_count,
      total_count: expected_total_count,
      total_unfiltered_count: expected_total_unfiltered_count,
    }
  end

  let!(:query) do
    <<~GRAPHQL
    query getSubcollections(
      $slug: Slug!, $order: EntityOrder!, $pageDirection: PageDirection!,
      $page: Int, $perPage: Int, $before: String, $after: String,
      $schema: [String!]
    ) {
      collection(slug: $slug) {
        collections(
          before: $before,
          after: $after,
          page: $page,
          pageDirection: $pageDirection,
          perPage: $perPage,
          order: $order,
          schema: $schema,
        ) {
          edges {
            node {
              id
            }
          }

          pageInfo {
            page
            perPage
            pageCount
            totalCount
            totalUnfilteredCount
          }
        }
      }
    }
    GRAPHQL
  end

  let(:expected_edges) { expect_edges :a, :b, :c, :d }

  let(:expected_shape) do
    gql.query do |q|
      q.prop :collection do |coll|
        coll.prop :collections do |colls|
          colls[:edges] = expected_edges
          colls[:page_info] = expected_page_info
        end
      end
    end
  end

  def expect_edges(*keys)
    keys.flatten.map do |key|
      subcollection = subcollections.fetch key

      { node: { id: subcollection.to_encoded_id } }
    end
  end

  context "when fetching in ascending title order" do
    it "gets the proper values" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  context "when specifying only perPage" do
    let(:per_page) { 2 }

    let(:expected_page) { 1 }

    let(:expected_edges) { super().take(2) }

    it "defaults to setting page 1" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  context "when specifying only page" do
    let(:page) { 1 }

    let(:expected_per_page) { Support::GraphQLAPI::Constants::DEFAULT_PER_PAGE_SIZE }

    it "defaults the global per-page default" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  context "when specifying a schema filter" do
    let(:schema_filter) { test_schema.system_slug }
    let(:expected_total_count) { 1 }

    let(:expected_edges) { expect_edges :d }

    it "has the correct total count vs total unfiltered count" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an execution error" do
    let(:top_level_error_count) { 1 }

    let(:expected_message) { be_present }

    let(:expected_shape) do
      top_level_error_count.times.map do
        {
          message: expected_message,
        }
      end
    end

    it "raises an execution error" do
      make_default_request! no_top_level_errors: false

      expect_graphql_response_errors expected_shape
    end
  end

  context "when setting before & page at the same time" do
    let(:before) { "MQ" }
    let(:page) { 1 }

    let(:expected_message) { "Cannot specify both page and before/after cursor" }

    it_behaves_like "an execution error"
  end

  context "when specifying an impossible filter" do
    let(:page) { 1 }

    let(:schema_filter) { "does_not:exist" }

    let(:expected_per_page) { Support::GraphQLAPI::Constants::DEFAULT_PER_PAGE_SIZE }
    let(:expected_page_count) { 0 }
    let(:expected_total_count) { 0 }
    let(:expected_edges) { be_blank }

    it "has the proper total_unfiltered_count but no results" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  context "when set to a ridiculous page" do
    let(:page) { 1000 }

    let(:expected_per_page) { Support::GraphQLAPI::Constants::DEFAULT_PER_PAGE_SIZE }

    let(:expected_edges) { be_blank }

    it "has the proper total_unfiltered_count but no results" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  context "when set to an invalid page" do
    let(:page) { -10 }

    it_behaves_like "an execution error"
  end

  context "when set to an invalid perPage" do
    let(:per_page) { 0 }

    it_behaves_like "an execution error"
  end
end
