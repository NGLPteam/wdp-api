# frozen_string_literal: true

RSpec.describe Mutations::DestroyCommunity, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:community) { FactoryBot.create :community }

    let!(:mutation_input) do
      {
        communityId: community.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        destroyCommunity: {
          destroyed: true,
          globalErrors: be_blank
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation destroyCommunity($input: DestroyCommunityInput!) {
        destroyCommunity(input: $input) {
          destroyed

          globalErrors { message }
        }
      }
      GRAPHQL
    end

    it "destroys the community" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change(Community, :count).by(-1)

      expect_graphql_response_data expected_shape
    end

    context "when the community has at least one collection" do
      let!(:collection) { FactoryBot.create :collection, community: community }

      let(:expected_shape) do
        {
          destroyCommunity: {
            destroyed: be_blank,
            globalErrors: [
              { message: I18n.t("dry_validation.errors.destroy_community_with_collections") }
            ]
          }
        }
      end

      it "fails to destroy the community" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same(Community, :count)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
