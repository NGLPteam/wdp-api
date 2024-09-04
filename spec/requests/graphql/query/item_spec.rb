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

          pageInfo {
            totalCount
          }
        }

        items {
          nodes { id }

          pageInfo {
            totalCount
          }
        }

        links {
          ... EntityLinksListDataFragment
        }
      }
    }

    fragment EntityLinksListDataFragment on EntityLinkConnection {
      nodes {
        id
        slug
        operator
        target {
          __typename
          ... on Item {
            slug
            title
            schemaDefinition {
              name
              kind
              id
            }
          }
          ... on Collection {
            slug
            title
            schemaDefinition {
              name
              kind
              id
            }
          }
          ... on Node {
            __isNode: __typename
            id
          }
        }
      }
    }
    GRAPHQL
  end

  let(:slug) { random_slug }

  let(:graphql_variables) { { slug:, } }

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "with a valid slug" do
      let_it_be(:item) { FactoryBot.create :item }

      let_it_be(:subitems) { FactoryBot.create_list :item, 2, parent: item }

      let_it_be(:contributors) do
        %i[person organization].map do |trait|
          FactoryBot.create :contributor, trait
        end
      end

      let_it_be(:item_contributions) do
        contributors.map do |contrib|
          FactoryBot.create :item_contribution, contributor: contrib, item:
        end
      end

      let(:slug) { item.system_slug }

      let(:expected_shape) do
        gql.query do |q|
          q.prop :item do |i|
            i[:title] = item.title

            i.prop :contributors do |c|
              c.prop :page_info do |pi|
                pi[:total_count] = contributors.size
              end
            end

            i.prop :items do |is|
              is.prop :page_info do |pi|
                pi[:total_count] = subitems.size
              end
            end
          end
        end
      end

      it "has the expected shape" do
        expect_request! do |req|
          req.effect! change(Ahoy::Event, :count).by(1)

          req.data! expected_shape
        end
      end
    end

    context "with an invalid slug" do
      let(:slug) { random_slug }

      let(:expected_shape) do
        gql.query do |q|
          q[:item] = be_nil
        end
      end

      it "returns nil" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end
  end

  it_behaves_like "a graphql type with firstItem" do
    let_it_be(:item) { FactoryBot.create :item }

    subject { item }
  end
end
