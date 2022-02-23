# frozen_string_literal: true

RSpec.describe Mutations::GrantAccess, type: :request, graphql: :mutation do
  let!(:current_user) { FactoryBot.create :user }

  let!(:token) { current_user.build_fake_token }

  mutation_query! <<~GRAPHQL
  mutation grantAccess($input: GrantAccessInput!) {
    grantAccess(input: $input) {
      granted

      ... ErrorFragment
    }
  }
  GRAPHQL

  let(:admin) { Role.fetch(:admin) }
  let(:manager) { Role.fetch(:manager) }
  let(:editor) { Role.fetch(:editor) }
  let(:reader) { Role.fetch(:reader) }

  let!(:community) { FactoryBot.create :community }

  let!(:entity) { FactoryBot.create :collection, community: community }
  let!(:role) { reader }
  let!(:user) { FactoryBot.create :user }

  let_mutation_input!(:entity_id) { entity.to_encoded_id }
  let_mutation_input!(:role_id) { role.to_encoded_id }
  let_mutation_input!(:user_id) { user.to_encoded_id }

  shared_examples_for "a successful grant" do
    let!(:expected_shape) do
      gql.mutation(:grant_access) do |m|
        m[:granted] = true
      end
    end

    it "grants the role on the entity idempotently" do
      expect_the_default_request.to change(AccessGrant, :count).by(1)

      expect_graphql_data expected_shape

      expect_the_default_request.to keep_the_same(AccessGrant, :count)

      expect_graphql_data expected_shape
    end
  end

  shared_examples_for "a failed grant" do
    let!(:expected_shape) do
      gql.mutation(:grant_access, no_errors: false) do |m|
        m[:granted] = be_blank
      end
    end

    it "does not grant the role" do
      expect_the_default_request.to keep_the_same(AccessGrant, :count)

      expect_graphql_data expected_shape
    end
  end

  shared_examples "a self-assign grant" do
    include_examples "a failed grant" do
      let(:expected_shape) do
        gql.mutation(:grant_access, no_errors: false) do |m|
          m[:granted] = be_blank

          m.global_errors do |ge|
            ge.error :cannot_grant_role_to_self
          end
        end
      end
    end
  end

  shared_examples "an insufficient permissions grant" do
    include_examples "a failed grant" do
      let(:expected_shape) do
        gql.mutation(:grant_access, no_errors: false) do |m|
          m[:granted] = be_blank

          m.global_errors do |ge|
            ge.error :cannot_grant_role_on_entity
          end
        end
      end
    end
  end

  shared_examples "an unassignable role grant" do
    include_examples "a failed grant" do
      let(:expected_shape) do
        gql.mutation(:grant_access, no_errors: false) do |m|
          m[:granted] = be_blank

          m.attribute_errors do |ae|
            ae.error :role_id, :cannot_grant_unassignable_role, role_name: role.name
          end
        end
      end
    end
  end

  context "as an admin" do
    let!(:current_user) { FactoryBot.create :user, :admin }

    context "when granting admin access on an entity" do
      let(:role) { admin }

      include_examples "an unassignable role grant"
    end

    context "when granting reader access on an entity" do
      include_examples "a successful grant"
    end

    context "when assigning a role to one's self" do
      let(:user) { current_user }

      include_examples "a self-assign grant"
    end
  end

  context "as a community manager" do
    before do
      WDPAPI::Container["access.grant"].call(manager, on: community, to: current_user)
    end

    context "when granting reader access on an entity" do
      include_examples "a successful grant"
    end

    context "when granting manager access on an entity" do
      let(:role) { manager }

      include_examples "an unassignable role grant"
    end
  end

  context "as a user with no access" do
    context "when granting reader access on an entity" do
      include_examples "an insufficient permissions grant"
    end
  end
end
