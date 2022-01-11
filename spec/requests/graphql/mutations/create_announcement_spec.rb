# frozen_string_literal: true

RSpec.describe Mutations::CreateAnnouncement, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation createAnnouncement($input: CreateAnnouncementInput!) {
    createAnnouncement(input: $input) {
      announcement {
        entity {
          ... on Node { id }
        }
        publishedOn
        header
        teaser
        body
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:entity) { FactoryBot.create :collection }

    let_mutation_input!(:entity_id) { entity.to_encoded_id }
    let_mutation_input!(:published_on) { Date.current }
    let_mutation_input!(:header) { "Some Header" }
    let_mutation_input!(:teaser) { "A teaser about the announcement" }
    let_mutation_input!(:body) { "A lot more content about the announcement." }

    let!(:expected_shape) do
      gql.mutation(:create_announcement) do |m|
        m.prop :announcement do |a|
          a.prop :entity do |e|
            e[:id] = entity_id
          end

          a[:published_on] = published_on.as_json
          a[:header] = header
          a[:teaser] = teaser
          a[:body] = body
        end
      end
    end

    context "with a collection" do
      it "creates an announcement" do
        expect_the_default_request.to change(Announcement, :count).by(1)

        expect_graphql_data expected_shape
      end

      context "when a required attribute is blank" do
        let_mutation_input!(:body) { "" }

        let(:expected_shape) do
          gql.mutation :create_announcement, no_errors: false do |m|
            m[:announcement] = be_blank

            m.errors do |e|
              e.error :body, :filled?
            end
          end
        end

        it "fails to create the announcement" do
          expect_the_default_request.to keep_the_same(Announcement, :count)

          expect_graphql_data expected_shape
        end
      end
    end
  end
end
