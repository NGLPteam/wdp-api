# frozen_string_literal: true

RSpec.describe "Query.communities", type: :request do
  let!(:token) { nil }

  let!(:graphql_variables) { {} }

  def make_default_request!
    make_graphql_request! query, token: token, variables: graphql_variables
  end

  context "when ordering" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:community_a3) do
      Timecop.freeze(3.days.ago) do
        FactoryBot.create :community, title: "AA"
      end
    end

    let!(:community_m2) do
      Timecop.freeze(2.days.ago) do
        FactoryBot.create :community, title: "MM"
      end
    end

    let!(:community_n4) do
      Timecop.freeze(4.days.ago) do
        FactoryBot.create :community, title: "NN"
      end
    end

    let!(:community_z1) do
      Timecop.freeze(1.day.ago) do
        FactoryBot.create :community, title: "ZZ"
      end
    end

    let!(:community_k0) do
      Timecop.freeze(1.hour.ago) do
        FactoryBot.create :community, title: "KK"
      end
    end

    let!(:keyed_models) do
      {
        a3: to_rep(community_a3),
        k0: to_rep(community_k0),
        m2: to_rep(community_m2),
        n4: to_rep(community_n4),
        z1: to_rep(community_z1),
      }
    end

    let!(:order) { "RECENT" }

    let!(:graphql_variables) { { order: order } }

    let!(:query) do
      <<~GRAPHQL
      query getOrderedCommunities($order: EntityOrder!) {
        communities(order: $order) {
          edges {
            node {
              id
              title
            }
          }
          pageInfo { totalCount }
        }
      }
      GRAPHQL
    end

    shared_examples_for "an ordered list of communities" do |order_value, *keys|
      let!(:order) { order_value }

      let!(:expected_shape) do
        {
          communities: {
            edges: keys.map { |k| { node: keyed_models.fetch(k) } },
            page_info: { total_count: keyed_models.size },
          },
        }
      end

      it "returns communities in the expected order" do
        make_default_request!

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end

    {
      "RECENT" => %i[k0 z1 m2 a3 n4],
      "OLDEST" => %i[n4 a3 m2 z1 k0],
      "PUBLISHED_ASCENDING" => %i[n4 a3 m2 z1 k0],
      "PUBLISHED_DESCENDING" => %i[k0 z1 m2 a3 n4],
      "TITLE_ASCENDING" => %i[a3 k0 m2 n4 z1],
      "TITLE_DESCENDING" => %i[z1 n4 m2 k0 a3],
      "SCHEMA_NAME_ASCENDING" => %i[a3 k0 m2 n4 z1],
      "SCHEMA_NAME_DESCENDING" => %i[a3 k0 m2 n4 z1],
    }.each do |order, keys|
      context "when ordered by #{order}" do
        include_examples "an ordered list of communities", order, *keys
      end
    end

    def to_rep(model)
      model.slice(:title).merge(id: model.to_encoded_id)
    end
  end
end
