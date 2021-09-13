# frozen_string_literal: true

RSpec.describe "Query.user", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getUser($slug: Slug!) {
      user(slug: $slug) {
        name
        slug
      }
    }
    GRAPHQL
  end

  let!(:token) { nil }

  let!(:graphql_variables) { {} }

  def make_default_request!
    make_graphql_request! query, token: token, variables: graphql_variables
  end

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "with a valid slug" do
      let!(:graphql_variables) { { slug: user.system_slug } }

      let!(:user) { FactoryBot.create :user }

      it "has the right name" do
        make_default_request!

        expect_graphql_response_data user: { name: user.name, slug: user.system_slug }
      end
    end

    context "with an invalid slug" do
      let!(:graphql_variables) { { slug: random_slug } }

      it "returns nil" do
        make_default_request!

        expect_graphql_response_data user: nil
      end
    end
  end
end
