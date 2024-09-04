# frozen_string_literal: true

RSpec.describe "Query.collection", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getCollection($slug: Slug!) {
      collection(slug: $slug) {
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

        collections { nodes { id } }

        items { nodes { id } }

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

  let_it_be(:collection, refind: true) { FactoryBot.create :collection }

  let(:slug) { collection.system_slug }

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "with a valid slug" do
      let!(:graphql_variables) { { slug:, } }

      let!(:subcollections) { FactoryBot.create_list :collection, 2, parent: collection }

      let!(:contributors) { %i[person organization].map { |trait| FactoryBot.create :contributor, trait } }

      let!(:items) { FactoryBot.create_list :item, 2, collection: }

      before do
        contributors.map do |contrib|
          FactoryBot.create :collection_contribution, contributor: contrib, collection:
        end
      end

      let(:expected_shape) do
        gql.query do |q|
          q.prop :collection do |c|
            c[:title] = collection.title

            c.prop :contributors do |con|
              con[:nodes] = have_length(contributors.size)
            end

            c.prop :items do |itm|
              itm[:nodes] = have_length(items.size)
            end

            c.prop :collections do |sub|
              sub[:nodes] = have_length(subcollections.size)
            end
          end
        end
      end

      it "fetches the right shape" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end

    context "when fetching announcements" do
      let(:query) do
        <<~GRAPHQL
        query getCollection($slug: Slug!, $announcementOrder: AnnouncementOrder!) {
          collection(slug: $slug) {
            announcements(order: $announcementOrder) {
              edges {
                node {
                  id
                  publishedOn
                  header
                  teaser
                  body
                }
              }
            }
          }
        }
        GRAPHQL
      end

      let!(:graphql_variables) do
        {
          slug:,
          announcement_order:,
        }
      end

      let(:announcement_order) { "RECENT" }

      let!(:today_announcement) { FactoryBot.create :announcement, :today, entity: collection }

      let!(:yesterday_announcement) { FactoryBot.create :announcement, :yesterday, entity: collection }

      let(:announcement_list) { [today_announcement, yesterday_announcement] }

      let(:announcement_edges) do
        announcement_list.map do |announcement|
          node = announcement.slice(:published_on, :header, :teaser, :body).merge(id: announcement.to_encoded_id).as_json

          {
            node:
          }
        end
      end

      let(:expected_shape) do
        gql.query do |q|
          q.prop :collection do |c|
            c.prop :announcements do |a|
              a[:edges] = announcement_edges
            end
          end
        end
      end

      context "when (order: RECENT)" do
        it "returns announcements in the correct order" do
          make_default_request!

          expect_graphql_data expected_shape
        end
      end

      context "when (order: OLDEST)" do
        let(:announcement_order) { "OLDEST" }
        let(:announcement_list) { [yesterday_announcement, today_announcement] }

        it "returns announcements in the correct order" do
          make_default_request!

          expect_graphql_data expected_shape
        end
      end
    end

    context "with an invalid slug" do
      let!(:graphql_variables) { { slug: random_slug } }

      let(:expected_shape) do
        gql.query do |c|
          c[:collection] = be_blank
        end
      end

      it "returns nil" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end
  end

  it_behaves_like "a graphql type with firstCollection" do
    subject { collection }
  end

  it_behaves_like "a graphql type with firstItem" do
    subject { collection }
  end
end
