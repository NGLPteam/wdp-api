# frozen_string_literal: true

RSpec.describe Mutations::RevokeAccess, type: :request, graphql: :mutation do
  let!(:current_user) { FactoryBot.create :user }

  let!(:token) { token_helper.build_token(from_user: current_user) }

  mutation_query! <<~GRAPHQL
  mutation revokeAccess($input: RevokeAccessInput!) {
    revokeAccess(input: $input) {
      revoked

      ... ErrorFragment
    }
  }
  GRAPHQL

  let(:admin) { Role.fetch(:admin) }
  let(:manager) { Role.fetch(:manager) }
  let(:editor) { Role.fetch(:editor) }
  let(:reader) { Role.fetch(:reader) }

  let!(:community) { FactoryBot.create :community }

  let!(:entity) { FactoryBot.create :collection, community: }
  let!(:role) { reader }
  let!(:user) { FactoryBot.create :user }

  let_mutation_input!(:entity_id) { entity.to_encoded_id }
  let_mutation_input!(:role_id) { role.to_encoded_id }
  let_mutation_input!(:user_id) { user.to_encoded_id }

  shared_examples_for "a successful revocation" do
    before do
      MeruAPI::Container["access.grant"].call(role, on: entity, to: user)
    end

    let!(:expected_shape) do
      gql.mutation(:revoke_access) do |m|
        m[:revoked] = true
      end
    end

    it "revokes the role on the entity idempotently" do
      expect_the_default_request.to change(AccessGrant, :count).by(-1)

      expect_graphql_data expected_shape

      expect_the_default_request.to keep_the_same(AccessGrant, :count)

      expect_graphql_data expected_shape
    end
  end

  shared_examples_for "a failed revocation" do
    let!(:expected_shape) do
      gql.mutation(:revoke_access, no_errors: false) do |m|
        m[:revoked] = be_blank
      end
    end

    it "does not revoke the role" do
      expect_the_default_request.to keep_the_same(AccessGrant, :count)

      expect_graphql_data expected_shape
    end
  end

  shared_examples "a self-assign revocation" do
    include_examples "a failed revocation" do
      let(:expected_shape) do
        gql.mutation(:revoke_access, no_errors: false) do |m|
          m[:revoked] = be_blank

          m.global_errors do |ge|
            ge.error :cannot_revoke_role_from_self
          end
        end
      end
    end
  end

  shared_examples "an insufficient permissions revocation" do
    include_examples "a failed revocation" do
      let(:expected_shape) do
        gql.mutation(:revoke_access, no_errors: false) do |m|
          m[:revoked] = be_blank

          m.global_errors do |ge|
            ge.error :cannot_revoke_role_on_entity
          end
        end
      end
    end
  end

  shared_examples "an unassignable role revocation" do
    include_examples "a failed revocation" do
      let(:expected_shape) do
        gql.mutation(:revoke_access, no_errors: false) do |m|
          m[:revoked] = be_blank

          m.attribute_errors do |ae|
            ae.error :role_id, :cannot_revoke_unassignable_role, role_name: role.name
          end
        end
      end
    end
  end

  context "as an admin" do
    let!(:current_user) { FactoryBot.create :user, :admin }

    context "when revoking admin access on an entity" do
      let(:role) { admin }

      include_examples "an unassignable role revocation"
    end

    context "when revoking reader access on an entity" do
      include_examples "a successful revocation"
    end

    context "when revoking a role from one's self" do
      let(:user) { current_user }

      include_examples "a self-assign revocation"
    end
  end

  context "as a community manager" do
    before do
      MeruAPI::Container["access.grant"].call(manager, on: community, to: current_user)
    end

    context "when revoking reader access on an entity" do
      include_examples "a successful revocation"
    end

    context "when revoking manager access on an entity" do
      let(:role) { manager }

      include_examples "an unassignable role revocation"
    end
  end

  context "as a user with no access" do
    context "when revoking reader access on an entity" do
      include_examples "an insufficient permissions revocation"
    end
  end
end
