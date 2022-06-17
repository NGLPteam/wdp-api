# frozen_string_literal: true

RSpec.describe "Query.users", type: :request do
  context "when ordering" do
    let(:token) { token_helper.build_token from_user: user_admin }

    let_it_be(:user_admin) do
      Timecop.freeze(4.days.ago) do
        FactoryBot.create :user, :admin, given_name: "Admin", family_name: "User", email: "admin@example.com", metadata: { testing: false }
      end
    end

    let_it_be(:user_aa) do
      Timecop.freeze(3.days.ago) do
        FactoryBot.create :user, given_name: "AA", family_name: "AA", email: "aa@example.com", metadata: { testing: false }
      end
    end

    let_it_be(:user_zz) do
      Timecop.freeze(2.days.ago) do
        FactoryBot.create :user, given_name: "ZZ", family_name: "ZZ", email: "zz@example.com", metadata: { testing: false }
      end
    end

    let_it_be(:user_test) do
      Timecop.freeze(1.day.ago) do
        FactoryBot.create :user, given_name: "Test", family_name: "User", email: "test@example.com", metadata: { testing: true }
      end
    end

    let_it_be(:default_admin_user) { user_admin }
    let_it_be(:default_user) { user_test }

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

    # We gotta make sure our keycloak default users are not present
    before do
      User.where.not(id: [user_admin, user_aa, user_test, user_zz]).destroy_all
    end

    shared_examples_for "an ordered list of users" do |order_value, *keys|
      let!(:order) { order_value }

      let!(:expected_shape) do
        gql.query do |q|
          q.prop :users do |u|
            u.array :edges do |e|
              keys.each do |k|
                e.item do |n|
                  n[:node] = keyed_users.fetch k
                end
              end
            end
            u[:page_info] = { total_count: keyed_users.size }
          end
        end
      end

      it "returns users in the expected order" do
        expect_request! do |req|
          req.data! expected_shape
        end
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
