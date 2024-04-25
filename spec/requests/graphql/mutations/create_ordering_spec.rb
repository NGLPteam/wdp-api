# frozen_string_literal: true

RSpec.describe Mutations::CreateOrdering, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation createOrdering($input: CreateOrderingInput!) {
    createOrdering(input: $input) {
      ordering {
        id
        name
        identifier
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:entity) { FactoryBot.create :collection }

    let!(:identifier) { "test_ordering" }
    let!(:name) { Faker::Lorem.sentence }
    let!(:select_input) do
      {
        direct: "DESCENDANTS",
        links: { contains: true, references: true }
      }
    end

    let!(:filter_input) do
      {
        schemas: []
      }
    end

    let!(:order_input) do
      [
        { path: "entity.updated_at", nulls: "LAST", direction: "DESCENDING" }
      ]
    end

    let!(:mutation_input) do
      {
        entityId: entity.to_encoded_id,
        identifier:,
        name:,
        select: select_input,
        filter: filter_input,
        order: order_input,
      }
    end

    let!(:expected_shape) do
      gql.mutation(:create_ordering) do |m|
        m.prop :ordering do |o|
          o[:id] = be_present
          o[:name] = name
          o[:identifier] = identifier
        end
      end
    end

    context "with a collection" do
      it "works" do
        expect_the_default_request.to change(Ordering, :count).by(1)

        expect_graphql_data expected_shape
      end
    end
  end
end
