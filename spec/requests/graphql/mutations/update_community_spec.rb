# frozen_string_literal: true

RSpec.describe Mutations::UpdateCommunity, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:community) { FactoryBot.create :community, title: old_title }

    let!(:old_title) { Faker::Lorem.unique.sentence }

    let!(:new_title) { Faker::Lorem.unique.sentence }

    let!(:mutation_input) do
      {
        communityId: community.to_encoded_id,
        title: new_title,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        updateCommunity: {
          community: {
            title: new_title
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updateCommunity($input: UpdateCommunityInput!) {
        updateCommunity(input: $input) {
          community {
            title
          }

          attributeErrors {
            path
            messages
          }
        }
      }
      GRAPHQL
    end

    it "updates a community" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change { community.reload.title }.from(old_title).to(new_title)

      expect_graphql_response_data expected_shape
    end

    context "with a blank title" do
      let(:new_title) { "" }

      let!(:expected_shape) do
        {
          updateCommunity: {
            community: be_blank,
            attributeErrors: [
              { path: "title", messages: ["must be filled"] },
            ]
          }
        }
      end

      it "fails to update the community" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to(keep_the_same { community.reload.title })

        expect_graphql_response_data expected_shape
      end
    end
  end
end
