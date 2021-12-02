# frozen_string_literal: true

RSpec.describe "Query.users", type: :request do
  let!(:token) { nil }

  let!(:graphql_variables) { {} }

  def make_default_request!
    make_graphql_request! query, token: token, variables: graphql_variables
  end

  context "when ordering" do
    let(:token) { token_helper.build_token from_user: user_admin }

    let!(:user_admin) do
      Timecop.freeze(4.days.ago) do
        FactoryBot.create :user, :admin, given_name: "Admin", family_name: "User", email: "admin@example.com", metadata: { testing: false }
      end
    end

    let!(:user_aa) do
      Timecop.freeze(3.days.ago) do
        FactoryBot.create :user, given_name: "AA", family_name: "AA", email: "aa@example.com", metadata: { testing: false }
      end
    end

    let!(:user_zz) do
      Timecop.freeze(2.days.ago) do
        FactoryBot.create :user, given_name: "ZZ", family_name: "ZZ", email: "zz@example.com", metadata: { testing: false }
      end
    end

    let!(:user_test) do
      Timecop.freeze(1.day.ago) do
        FactoryBot.create :user, given_name: "Test", family_name: "User", email: "test@example.com", metadata: { testing: true }
      end
    end

    let!(:keyed_users) do
      {
        admin: admin,
        aa: aa,
        test: test,
        zz: zz,
      }
    end

    let!(:admin) { to_rep user_admin }
    let!(:aa) { to_rep user_aa }
    let!(:test) { to_rep user_test }
    let!(:zz) { to_rep user_zz }

    let!(:order) { "RECENT" }

    let!(:graphql_variables) { { order: order } }

    let!(:query) do
      <<~GRAPHQL
      query getOrderedUsers($order: UserOrder!) {
        users(order: $order) {
          edges {
            node {
              id
              name
              globalAdmin
            }
          }
          pageInfo { totalCount }
        }
      }
      GRAPHQL
    end

    shared_examples_for "an ordered list of users" do |order_value, *keys|
      let!(:order) { order_value }

      let!(:expected_shape) do
        {
          users: {
            edges: keys.map { |k| { node: keyed_users.fetch(k) } },
            page_info: { total_count: keyed_users.size },
          }
        }
      end

      it "returns users in the expected order" do
        make_default_request!

        expect_graphql_response_data expected_shape, decamelize: true
      end
    end

    {
      "RECENT" => %i[test zz aa admin],
      "OLDEST" => %i[admin aa zz test],
      "ADMINS_FIRST" => %i[admin aa zz test],
      "ADMINS_RECENT" => %i[admin zz aa test],
      "NAME_ASCENDING" => %i[aa admin test zz],
      "NAME_DESCENDING" => %i[zz test admin aa],
      "EMAIL_ASCENDING" => %i[aa admin test zz],
      "EMAIL_DESCENDING" => %i[zz test admin aa],
    }.each do |order, keys|
      context "when ordered by #{order}" do
        include_examples "an ordered list of users", order, *keys
      end
    end

    def to_rep(user)
      user.slice(:name).merge(id: user.to_encoded_id, global_admin: user.has_global_admin_access?)
    end
  end
end
