# frozen_string_literal: true

RSpec.describe "Query.roles", type: :request do
  let!(:token) { nil }

  let!(:graphql_variables) { {} }

  def make_default_request!
    make_graphql_request! query, token: token, variables: graphql_variables
  end

  context "when ordering" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:role_a3) do
      Timecop.freeze(3.days.ago) do
        FactoryBot.create :role, name: "AA"
      end
    end

    let!(:role_m1) do
      Timecop.freeze(1.day.ago) do
        FactoryBot.create :role, name: "MM"
      end
    end

    let!(:role_z2) do
      Timecop.freeze(2.days.ago) do
        FactoryBot.create :role, name: "ZZ"
      end
    end

    let!(:keyed_models) do
      {
        a3: to_rep(role_a3),
        m1: to_rep(role_m1),
        z2: to_rep(role_z2),
      }
    end

    def to_rep(role)
      role.slice(:name).merge(id: role.to_encoded_id)
    end

    let!(:order) { "RECENT" }

    let!(:graphql_variables) { { order: order } }

    let!(:query) do
      <<~GRAPHQL
      query getOrderedRoles($order: RoleOrder!) {
        roles(order: $order) {
          edges {
            node {
              id
              name
            }
          }
          pageInfo { totalCount }
        }
      }
      GRAPHQL
    end

    shared_examples_for "an ordered list of roles" do |order_value, *keys|
      let!(:order) { order_value }

      let!(:expected_shape) do
        {
          roles: {
            edges: keys.map { |k| { node: keyed_models.fetch(k) } },
            page_info: { total_count: keyed_models.size },
          },
        }
      end

      it "returns roles in the expected order" do
        make_default_request!

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end

    {
      "RECENT" => %i[m1 z2 a3],
      "OLDEST" => %i[a3 z2 m1],
      "NAME_ASCENDING" => %i[a3 m1 z2],
      "NAME_DESCENDING" => %i[z2 m1 a3],
    }.each do |order, keys|
      context "when ordered by #{order}" do
        include_examples "an ordered list of roles", order, *keys
      end
    end
  end
end
