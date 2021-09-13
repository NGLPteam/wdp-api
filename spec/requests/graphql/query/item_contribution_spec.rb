# frozen_string_literal: true

RSpec.describe "Query.itemContribution", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getItemContribution($slug: Slug!) {
      itemContribution(slug: $slug) {
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
      let!(:graphql_variables) { { slug: item_contribution.system_slug } }

      let!(:item_contribution) { FactoryBot.create :item_contribution }

      it "has the right value" do
        make_default_request!

        expect_graphql_response_data itemContribution: { slug: item_contribution.system_slug }
      end
    end

    context "with an invalid slug" do
      let!(:graphql_variables) { { slug: random_slug } }

      it "returns nil" do
        make_default_request!

        expect_graphql_response_data itemContribution: nil
      end
    end
  end
end
