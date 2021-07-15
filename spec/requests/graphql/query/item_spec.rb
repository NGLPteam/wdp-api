# frozen_string_literal: true

RSpec.describe "Query.item", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getItem($slug: Slug!) {
      item(slug: $slug) {
        title

        contributors {
          nodes {
            ... on OrganizationContributor {
              legalName
            }

            ... on PersonContributor {
              givenName
              familyName
            }
          }
        }

        items { nodes { id } }

        items { nodes { id } }
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
      let!(:graphql_variables) { { slug: item.system_slug } }

      let!(:item) { FactoryBot.create :item }

      let!(:subitems) { FactoryBot.create_list :item, 2, parent: item }

      let!(:contributors) { %i[person organization].map { |trait| FactoryBot.create :contributor, trait } }

      before do
        contributors.map do |contrib|
          FactoryBot.create :item_contribution, contributor: contrib, item: item
        end
      end

      it "has the right title" do
        make_default_request!

        expect_graphql_response_data item: { title: item.title }
      end

      it "has the right number of contributors" do
        make_default_request!

        expect(graphql_response(:data, :item, :contributors, :nodes)).to have(contributors.length).items
      end

      it "has the right number of subitems" do
        make_default_request!

        expect(graphql_response(:data, :item, :items, :nodes)).to have(subitems.length).items
      end
    end

    context "with an invalid slug" do
      let!(:graphql_variables) { { slug: random_slug } }

      it "returns nil" do
        make_default_request!

        expect_graphql_response_data item: nil
      end
    end
  end
end
