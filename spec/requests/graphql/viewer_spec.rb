# frozen_string_literal: true

RSpec.describe "GraphQL Viewer", type: :request do
  context "when authenticated" do
    let(:email) { Faker::Internet.email }
    let(:token) { token_helper.build_token data: { email: } }

    let(:expected_shape) do
      {
        viewer: {
          email:,
        },
      }
    end

    it "has the expected email" do
      make_graphql_request!(<<~GRAPHQL, token:)
      query getViewerQuery {
        viewer {
          email
        }
      }
      GRAPHQL

      expect_graphql_data expected_shape
    end
  end
end
