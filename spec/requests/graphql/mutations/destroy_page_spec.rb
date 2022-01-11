# frozen_string_literal: true

RSpec.describe Mutations::DestroyPage, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation destroyPage($input: DestroyPageInput!) {
    destroyPage(input: $input) {
      destroyed
      destroyedId

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:page) { FactoryBot.create :page }

    let_mutation_input!(:page_id) { page.to_encoded_id }

    let!(:expected_shape) do
      gql.mutation(:destroy_page) do |m|
        m[:destroyed] = true
        m[:destroyed_id] = eq(page_id).and(be_an_encoded_id.of_a_deleted_model)
      end
    end

    it "destroys the page" do
      expect_the_default_request.to change(Page, :count).by(-1)

      expect_graphql_data expected_shape
    end
  end
end
