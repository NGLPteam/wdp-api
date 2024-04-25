# frozen_string_literal: true

RSpec.describe Mutations::DestroyEntityLink, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation destroyEntityLink($input: DestroyEntityLinkInput!) {
    destroyEntityLink(input: $input) {
      destroyed
      destroyedId

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:entity_link, refind: true) { FactoryBot.create :entity_link }

  let_mutation_input!(:entity_link_id) { entity_link.to_encoded_id }

  as_an_admin_user do
    let!(:expected_shape) do
      gql.mutation :destroy_entity_link do |m|
        m[:destroyed] = true
        m[:destroyed_id] = eq(entity_link_id).and(be_an_encoded_id.of_a_deleted_model)
      end
    end

    it "destroys the EntityLink" do
      expect_request! do |req|
        req.effect! change(EntityLink, :count).by(-1)

        req.data! expected_shape
      end
    end
  end
end
