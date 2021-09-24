# frozen_string_literal: true

RSpec.describe Mutations::DestroyEntityLink, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:entity_link) { FactoryBot.create :entity_link }

    let!(:mutation_input) do
      {
        entity_link_id: entity_link.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        destroyEntityLink: {
          destroyed: true,
          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation destroyEntityLink($input: DestroyEntityLinkInput!) {
        destroyEntityLink(input: $input) {
          destroyed

          errors { message }
        }
      }
      GRAPHQL
    end

    it "destroys the EntityLink" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(EntityLink, :count).by(-1)

      expect_graphql_response_data expected_shape
    end
  end
end
