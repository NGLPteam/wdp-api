# frozen_string_literal: true

RSpec.describe "Query.contributors", type: :request, disable_ordering_refresh: true do
  include_context "sans entity sync"

  context "when ordering" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let(:community) { FactoryBot.create :community }
    let(:collection) { FactoryBot.create :collection, community: community }

    def create_person_contributor_at(time, item_count:, **attributes)
      Timecop.freeze time do
        FactoryBot.create(:contributor, :person, **attributes).tap do |contributor|
          FactoryBot.create_list(:item, item_count, collection: collection).map do |item|
            FactoryBot.create :item_contribution, contributor: contributor, item: item
          end
        end
      end
    end

    let!(:contributor_asimov) do
      create_person_contributor_at(1.day.ago, item_count: 5, given_name: "Isaac", family_name: "Asimov", affiliation: "everything")
    end

    let!(:contributor_salinger) do
      create_person_contributor_at(3.days.ago, item_count: 1, given_name: "J.D.", family_name: "Salinger", affiliation: "fiction")
    end

    let!(:contributor_angelou) do
      create_person_contributor_at(2.days.ago, item_count: 2, given_name: "Maya", family_name: "Angelou", affiliation: "poetry")
    end

    let!(:contributor_shelley) do
      create_person_contributor_at(4.days.ago, item_count: 2, given_name: "Mary", family_name: "Shelley", affiliation: "fiction")
    end

    let!(:keyed_models) do
      {
        asimov: to_rep(contributor_asimov),
        salinger: to_rep(contributor_salinger),
        shelley: to_rep(contributor_shelley),
        angelou: to_rep(contributor_angelou),
      }
    end

    def to_rep(model)
      {
        name: model.safe_name,
        id: model.to_encoded_id,
      }
    end

    let!(:order) { "RECENT" }

    let!(:graphql_variables) { { order: order } }

    let!(:query) do
      <<~GRAPHQL
      query getOrderedContributors($order: ContributorOrder!) {
        contributors(order: $order) {
          edges {
            node {
              ... on Node { id }
              ... on Contributor { name }
            }
          }
          pageInfo { totalCount }
        }
      }
      GRAPHQL
    end

    shared_examples_for "an ordered list of contributors" do |order_value, *keys|
      let!(:order) { order_value }

      let!(:expected_shape) do
        {
          contributors: {
            edges: keys.map { |k| { node: keyed_models.fetch(k) } },
            page_info: { total_count: keyed_models.size },
          },
        }
      end

      it "returns contributors in the expected order" do
        make_default_request!

        expect_graphql_data expected_shape
      end
    end

    {
      "RECENT" => %i[asimov angelou salinger shelley],
      "OLDEST" => %i[shelley salinger angelou asimov],
      "MOST_CONTRIBUTIONS" => %i[asimov angelou shelley salinger],
      "LEAST_CONTRIBUTIONS" => %i[salinger angelou shelley asimov],
      "NAME_ASCENDING" => %i[angelou asimov salinger shelley],
      "NAME_DESCENDING" => %i[shelley salinger asimov angelou],
      "AFFILIATION_ASCENDING" => %i[asimov salinger shelley angelou],
      "AFFILIATION_DESCENDING" => %i[angelou salinger shelley asimov],
    }.each do |order, keys|
      context "when ordered by #{order}" do
        include_examples "an ordered list of contributors", order, *keys
      end
    end
  end
end
