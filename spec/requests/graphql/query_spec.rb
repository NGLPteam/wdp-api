# frozen_string_literal: true

RSpec.describe "GraphQL Query", type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    describe "using the relay node resolver" do
      let!(:collection) { FactoryBot.create :collection }

      it "works as expected" do
        variables = { id: collection.to_encoded_id }

        make_graphql_request! <<~GRAPHQL, token: token, variables: variables
        query($id: ID!) {
          node(id: $id) {
            ... on Collection {
              title
            }
          }
        }
        GRAPHQL

        expect_graphql_response_data node: { title: collection.title }
      end
    end

    describe "fetching a list of communities" do
      let!(:communities) { FactoryBot.create_list :community, 5 }

      it "has the expected count" do
        make_graphql_request! <<~GRAPHQL, token: token
        query getCommunities {
          communities {
            nodes {
              id
            }
          }
        }
        GRAPHQL

        expect(graphql_response(:data, :communities, :nodes)).to have(5).items
      end
    end

    describe "fetching a single collection" do
      let!(:collection) { FactoryBot.create :collection }

      let!(:query) do
        <<~GRAPHQL
        query getCollection($slug: Slug!) {
          collection(slug: $slug) {
            title
          }
        }
        GRAPHQL
      end

      it "can find by slug" do
        make_graphql_request! query, token: token, variables: { slug: collection.system_slug }

        expect_graphql_response_data collection: { title: collection.title }
      end

      it "returns nil when not found" do
        make_graphql_request! query, token: token, variables: { slug: random_slug }

        expect_graphql_response_data collection: nil
      end
    end

    describe "fetching a single item" do
      let!(:item) { FactoryBot.create :item }

      let!(:query) do
        <<~GRAPHQL
        query($slug: Slug!) {
          item(slug: $slug) {
            title
          }
        }
        GRAPHQL
      end

      it "can find by slug" do
        make_graphql_request! query, token: token, variables: { slug: item.system_slug }

        expect_graphql_response_data item: { title: item.title }
      end

      it "returns nil when not found" do
        make_graphql_request! query, token: token, variables: { slug: random_slug }

        expect_graphql_response_data item: nil
      end
    end

    describe "fetching a list of roles" do
      let!(:roles) { FactoryBot.create_list :role, 4 }

      it "fetches all known roles in the system" do
        make_graphql_request! <<~GRAPHQL, token: token
        query getRoles {
          roles {
            nodes {
              id
              allowedActions
            }
          }
        }
        GRAPHQL

        expect(graphql_response(:data, :roles, :nodes)).to have(4).items
      end
    end

    describe "fetching contributors" do
      let!(:people) { FactoryBot.create_list :contributor, 2, :person }
      let!(:organizations) { FactoryBot.create_list :contributor, 2, :organization }

      let(:filter_kind) { "ALL" }

      let!(:graphql_variables) do
        {
          kind: filter_kind
        }
      end

      let!(:query) do
        <<~GRAPHQL
        query getContributors($kind: ContributorFilterKind) {
          contributors(kind: $kind) {
            nodes {
              __typename

              ... on OrganizationContributor {
                legalName
              }

              ... on PersonContributor {
                givenName
                familyName
              }
            }
          }
        }
        GRAPHQL
      end

      let(:graphql_query_options) do
        {
          token: token,
          variables: graphql_variables
        }
      end

      it "can fetch all contributors" do
        make_graphql_request! query, graphql_query_options

        expect(graphql_response(:data, :contributors, :nodes)).to have(4).items
      end

      context "when filtering only organizations" do
        let(:filter_kind) { "ORGANIZATION" }

        it "fetches only people" do
          make_graphql_request! query, graphql_query_options

          expect(graphql_response(:data, :contributors, :nodes)).to have(2).items.and all(have_typename("OrganizationContributor"))
        end
      end

      context "when filtering only people" do
        let(:filter_kind) { "PERSON" }

        it "fetches only people" do
          make_graphql_request! query, graphql_query_options

          expect(graphql_response(:data, :contributors, :nodes)).to have(2).items.and all(have_typename("PersonContributor"))
        end
      end
    end
  end
end
