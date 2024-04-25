# frozen_string_literal: true

RSpec.describe "Query.roles", type: :request do
  let!(:token) { nil }

  let!(:graphql_variables) { {} }

  def make_default_request!
    make_graphql_request! query, token:, variables: graphql_variables
  end

  context "when ordering" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:role_admin) { Role.fetch(:admin) }
    let!(:role_manager) { Role.fetch(:manager) }
    let!(:role_editor) { Role.fetch(:editor) }
    let!(:role_reader) { Role.fetch(:reader) }

    let!(:role_a3) do
      Timecop.freeze(3.days.ago) do
        FactoryBot.create :role, name: "AA", custom_priority: 100
      end
    end

    let!(:role_m1) do
      Timecop.freeze(1.day.ago) do
        FactoryBot.create :role, name: "MM", custom_priority: 300
      end
    end

    let!(:role_z2) do
      Timecop.freeze(2.days.ago) do
        FactoryBot.create :role, name: "ZZ", custom_priority: 200
      end
    end

    let!(:keyed_models) do
      {
        admin: to_rep(role_admin),
        manager: to_rep(role_manager),
        editor: to_rep(role_editor),
        reader: to_rep(role_reader),
        a3: to_rep(role_a3),
        m1: to_rep(role_m1),
        z2: to_rep(role_z2),
      }
    end

    def to_rep(role)
      role.slice(:name).merge(id: role.to_encoded_id)
    end

    let!(:order) { "RECENT" }

    let!(:graphql_variables) { { order: } }

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

    shared_examples_for "an ordered list of roles" do |order_value, kind, reverse = false|
      let!(:order) { order_value }
      let!(:example_kind) { kind }
      let!(:example_reverse) { reverse }

      let(:keys) do
        keyed_models.keys.sort do |akey, bkey|
          a = public_send(:"role_#{akey}")
          b = public_send(:"role_#{bkey}")

          case kind
          when :created
            comp = reverse ? b.created_at <=> a.created_at : a.created_at <=> b.created_at

            if comp == 0
              a.name <=> b.name
            else
              comp
            end
          when :name
            reverse ? b.name <=> a.name : a.name <=> b.name
          else
            a.priority <=> b.priority
          end
        end
      end

      let!(:reps) { keys.map { |k| keyed_models.fetch(k) } }
      let!(:edges) { reps.map { |node| { node: } } }

      let!(:expected_shape) do
        {
          roles: {
            edges:,
            page_info: { total_count: keyed_models.size },
          },
        }
      end

      it "returns roles in the expected order" do
        make_default_request!

        expect_graphql_data expected_shape
      end
    end

    {
      "DEFAULT" => [:priority, false],
      "RECENT" => [:created, true],
      "OLDEST" => [:created, false],
      "NAME_ASCENDING" => [:name, false],
      "NAME_DESCENDING" => [:name, true],
    }.each do |order, (kind, reverse)|
      xcontext "when ordered by #{order}" do
        include_examples "an ordered list of roles", order, kind, reverse
      end
    end
  end
end
