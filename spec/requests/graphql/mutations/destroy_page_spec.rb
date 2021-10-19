# frozen_string_literal: true

RSpec.describe Mutations::DestroyPage, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:page) { FactoryBot.create :page }

    let!(:mutation_input) do
      {
        pageId: page.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        destroyPage: {
          destroyed: true,
          destroyedId: a_kind_of(String),
          globalErrors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation destroyPage($input: DestroyPageInput!) {
        destroyPage(input: $input) {
          destroyed
          destroyedId

          globalErrors { message }
        }
      }
      GRAPHQL
    end

    it "destroys the page" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(Page, :count).by(-1)

      expect_graphql_response_data expected_shape

      expect(
        graphql_response(
          :data, :destroy_page, :destroyed_id,
          decamelize: true
        )
      ).to be_an_encoded_id.of_a_deleted_model
    end
  end
end
