# frozen_string_literal: true

RSpec.describe Mutations::UpdateOrdering, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:ordering) { FactoryBot.create :ordering, :collection }

    let!(:name) { Faker::Lorem.sentence }
    let!(:select_input) do
      {
        direct: "DESCENDANTS",
        links: { contains: false, references: true }
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
        orderingId: ordering.to_encoded_id,
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
        updateOrdering: {
          ordering: {
            id: be_present,
            name: name,
          },
          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updateOrdering($input: UpdateOrderingInput!) {
        updateOrdering(input: $input) {
          ordering {
            id
            name
          }

          errors { message }
        }
      }
      GRAPHQL
    end

    after do
      clear_enqueued_jobs
    end

    context "with a collection" do
      it "works" do
        clear_enqueued_jobs

        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Ordering, :count)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
