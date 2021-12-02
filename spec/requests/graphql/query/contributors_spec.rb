# frozen_string_literal: true

RSpec.describe "Query.contributors", type: :request do
  let!(:token) { nil }

  let!(:graphql_variables) { {} }

  def make_default_request!
    make_graphql_request! query, token: token, variables: graphql_variables
  end

  context "when ordering" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor_asimov) do
      Timecop.freeze(1.day.ago) do
        FactoryBot.create(:contributor, :person, given_name: "Isaac", family_name: "Asimov", affiliation: "everything").tap do |contributor|
          FactoryBot.create_list :item_contribution, 5, contributor: contributor
        end
      end
    end

    let!(:contributor_salinger) do
      Timecop.freeze(3.days.ago) do
        FactoryBot.create(:contributor, :person, given_name: "J.D.", family_name: "Salinger", affiliation: "fiction").tap do |contributor|
          FactoryBot.create_list :item_contribution, 1, contributor: contributor
        end
      end
    end

    let!(:contributor_angelou) do
      Timecop.freeze(2.days.ago) do
        FactoryBot.create(:contributor, :person, given_name: "Maya", family_name: "Angelou", affiliation: "poetry").tap do |contributor|
          FactoryBot.create_list :item_contribution, 2, contributor: contributor
        end
      end
    end

    let!(:contributor_shelley) do
      Timecop.freeze(4.days.ago) do
        FactoryBot.create(:contributor, :person, given_name: "Mary", family_name: "Shelley", affiliation: "fiction").tap do |contributor|
          FactoryBot.create_list :item_contribution, 2, contributor: contributor
        end
      end
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

        expect_graphql_response_data expected_shape, decamelize: true
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
