# frozen_string_literal: true

RSpec.describe Mutations::DestroyContributor, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:contributor) { FactoryBot.create :contributor, :person }

    let!(:mutation_input) do
      {
        contributorId: contributor.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        destroyContributor: {
          destroyed: true,
          errors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation destroyContributor($input: DestroyContributorInput!) {
        destroyContributor(input: $input) {
          destroyed

          errors { message }
        }
      }
      GRAPHQL
    end

    it "destroys the contributor" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(Contributor, :count).by(-1)

      expect_graphql_response_data expected_shape
    end
  end
end
