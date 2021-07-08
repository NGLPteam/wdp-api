# frozen_string_literal: true

RSpec.describe Mutations::CreateCommunity, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:name) { Faker::Lorem.sentence }

    let!(:mutation_input) do
      {
        name: name,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        createCommunity: {
          community: {
            name: name
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation createCommunity($input: CreateCommunityInput!) {
        createCommunity(input: $input) {
          community {
            name
          }
        }
      }
      GRAPHQL
    end

    it "creates a community" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(Community, :count).by(1)

      expect_graphql_response_data expected_shape
    end
  end
end
