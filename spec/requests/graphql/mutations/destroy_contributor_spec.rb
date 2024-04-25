# frozen_string_literal: true

RSpec.describe Mutations::DestroyContributor, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
      mutation destroyContributor($input: DestroyContributorInput!) {
        destroyContributor(input: $input) {
          destroyed
          destroyedId

          ... ErrorFragment
        }
      }
  GRAPHQL

  let_it_be(:contributor, refind: true) { FactoryBot.create :contributor, :person }

  as_an_admin_user do
    let_mutation_input!(:contributor_id) { contributor.to_encoded_id }

    let!(:expected_shape) do
      gql.mutation :destroy_contributor do |m|
        m[:destroyed] = true
        m[:destroyed_id] = contributor_id
      end
    end

    it "destroys the contributor" do
      expect_request! do |req|
        req.effect! change(Contributor, :count).by(-1)

        req.data! expected_shape
      end
    end
  end
end
