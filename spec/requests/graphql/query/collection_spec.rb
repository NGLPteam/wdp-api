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
      }
    }
    GRAPHQL
  end

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "with a valid slug" do
      let!(:graphql_variables) { { slug: collection.system_slug } }

      let!(:collection) { FactoryBot.create :collection }

      let!(:subcollections) { FactoryBot.create_list :collection, 2, parent: collection }

      let!(:contributors) { %i[person organization].map { |trait| FactoryBot.create :contributor, trait } }

      let!(:items) { FactoryBot.create_list :item, 2, collection: collection }

      before do
        contributors.map do |contrib|
          FactoryBot.create :collection_contribution, contributor: contrib, collection: collection
        end
      end

      it "has the right title" do
        make_default_request!

        expect_graphql_response_data collection: { title: collection.title }
      end

      it "has the right number of contributors" do
        make_default_request!

        expect(graphql_response(:data, :collection, :contributors, :nodes)).to have(contributors.length).items
      end

      it "has the right number of items" do
        make_default_request!

        expect(graphql_response(:data, :collection, :items, :nodes)).to have(items.length).items
      end

      it "has the right number of subcollections" do
        make_default_request!

        expect(graphql_response(:data, :collection, :collections, :nodes)).to have(subcollections.length).items
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
          slug: collection.system_slug,
          announcement_order: announcement_order,
        }
      end

      let(:announcement_order) { "RECENT" }

      let!(:collection) { FactoryBot.create :collection }

      let!(:today_announcement) { FactoryBot.create :announcement, :today, entity: collection }
      let!(:yesterday_announcement) { FactoryBot.create :announcement, :yesterday, entity: collection }

      let(:announcement_list) { [today_announcement, yesterday_announcement] }

      let(:announcement_edges) do
        announcement_list.map do |announcement|
          node = announcement.slice(:published_on, :header, :teaser, :body).merge(id: announcement.to_encoded_id).as_json

          {
            node: node
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

      it "returns nil" do
        make_default_request!

        expect_graphql_response_data collection: nil
      end
    end
  end

  it_behaves_like "a graphql type with firstCollection" do
    let!(:collection) { FactoryBot.create :collection }

    subject { collection }
  end

  it_behaves_like "a graphql type with firstItem" do
    let!(:collection) { FactoryBot.create :collection }

    subject { collection }
  end
end
