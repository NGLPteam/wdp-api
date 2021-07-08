# frozen_string_literal: true

RSpec.describe "GraphQL Viewer", type: :request do
  context "when authenticated" do
    let(:email) { Faker::Internet.safe_email }
    let(:token) { token_helper.build_token data: { email: email } }

    it "has the expected email" do
      make_graphql_request! <<~GRAPHQL, token: token
      query getViewerQuery {
        viewer {
          email
        }
      }
      GRAPHQL

      expect_graphql_response_data viewer: { email: email }
    end
  end
end
