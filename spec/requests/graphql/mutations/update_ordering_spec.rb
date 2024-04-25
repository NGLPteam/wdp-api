# frozen_string_literal: true

RSpec.describe Mutations::UpdateOrdering, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation updateOrdering($input: UpdateOrderingInput!) {
    updateOrdering(input: $input) {
      ordering {
        id
        name
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:ordering, refind: true) { FactoryBot.create :ordering, :collection }

  let_mutation_input!(:ordering_id) { ordering.to_encoded_id }

  let_mutation_input!(:name) { Faker::Lorem.sentence }

  let_mutation_input!(:select) do
    {
      direct: "DESCENDANTS",
      links: { contains: false, references: true }
    }
  end

  let_mutation_input!(:filter) do
    {
      schemas: []
    }
  end

  let_mutation_input!(:order) do
    [
      { path: "entity.updated_at", nulls: "LAST", direction: "DESCENDING" }
    ]
  end

  as_an_admin_user do
    let(:expected_shape) do
      gql.mutation :update_ordering do |m|
        m.prop :ordering do |ord|
          ord[:id] = ordering_id
          ord[:name] = name
        end
      end
    end

    before do
      clear_enqueued_jobs
    end

    after do
      clear_enqueued_jobs
    end

    context "with a collection" do
      it "works" do
        expect_request! do |req|
          req.effect! change { ordering.reload.updated_at }

          req.data! expected_shape
        end
      end
    end
  end
end
