# frozen_string_literal: true

RSpec.describe Mutations::GrantAccess, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:entity) { FactoryBot.create :collection }
    let!(:role) { FactoryBot.create :role, :reader }
    let!(:user) { FactoryBot.create :user }

    let!(:mutation_input) do
      {
        entityId: entity.to_encoded_id,
        roleId: role.to_encoded_id,
        userId: user.to_encoded_id,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    it "can grant access to an entity" do
      expect do
        make_graphql_request! <<~GRAPHQL, token: token, variables: graphql_variables
        mutation grantAccess($input: GrantAccessInput!) {
          grantAccess(input: $input) {
            granted
          }
        }
        GRAPHQL
      end.to change(AccessGrant, :count).by(1)

      expect_graphql_response_data grantAccess: { granted: true }
    end
  end
end
