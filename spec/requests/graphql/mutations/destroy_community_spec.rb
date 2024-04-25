# frozen_string_literal: true

RSpec.describe Mutations::DestroyCommunity, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation destroyCommunity($input: DestroyCommunityInput!) {
    destroyCommunity(input: $input) {
      destroyed
      destroyedId

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:community, refind: true) { FactoryBot.create :community }

  let_mutation_input!(:community_id) { community.to_encoded_id }

  as_an_admin_user do
    let!(:expected_shape) do
      gql.mutation :destroy_community do |m|
        m[:destroyed] = true
        m[:destroyed_id] = community_id
      end
    end

    it "destroys the community" do
      expect_request! do |req|
        req.effect! change(Community, :count).by(-1)

        req.data! expected_shape
      end
    end

    context "when the community has at least one collection" do
      let!(:collection) { FactoryBot.create :collection, community: }

      let(:expected_shape) do
        gql.mutation :destroy_community, no_global_errors: false do |m|
          m[:destroyed] = be_blank
          m[:destroyed_id] = be_blank

          m.global_errors do |ge|
            ge.error :destroy_community_with_collections
          end
        end
      end

      it "fails to destroy the community" do
        expect_request! do |req|
          req.effect! keep_the_same(Community, :count)

          req.data! expected_shape
        end
      end
    end
  end
end
