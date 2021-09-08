# frozen_string_literal: true

RSpec.describe Mutations::CreateCommunity, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:title) { Faker::Lorem.sentence }

    let!(:mutation_input) do
      {
        title: title,
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
            title: title
          },
          attributeErrors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation createCommunity($input: CreateCommunityInput!) {
        createCommunity(input: $input) {
          community {
            title
          }

          attributeErrors {
            path
            messages
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

    context "with a blank title" do
      let(:title) { "" }

      let!(:expected_shape) do
        {
          createCommunity: {
            community: be_blank,
            attributeErrors: [
              { path: "title", messages: ["must be filled"] },
            ]
          }
        }
      end

      it "fails to create a community" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Community, :count)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
