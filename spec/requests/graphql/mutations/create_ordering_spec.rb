# frozen_string_literal: true

RSpec.describe Mutations::CreateOrdering, type: :request do
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
        identifier: identifier,
        name: name,
        select: select_input,
        filter: filter_input,
        order: order_input,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        createOrdering: {
          ordering: {
            id: be_present,
            name: name,
            identifier: identifier
          },
          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation createOrdering($input: CreateOrderingInput!) {
        createOrdering(input: $input) {
          ordering {
            id
            name
            identifier
          }

          errors { message }
        }
      }
      GRAPHQL
    end

    context "with a collection" do
      it "works" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change(Ordering, :count).by(1)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
