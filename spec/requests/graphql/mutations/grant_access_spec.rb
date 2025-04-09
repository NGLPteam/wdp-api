# frozen_string_literal: true

RSpec.describe Mutations::GrantAccess, type: :request, graphql: :mutation, grants_access: true do
  mutation_query! <<~GRAPHQL
  mutation grantAccess($input: GrantAccessInput!) {
    grantAccess(input: $input) {
      granted

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:admin) { Role.fetch(:admin) }
  let_it_be(:manager) { Role.fetch(:manager) }
  let_it_be(:editor) { Role.fetch(:editor) }
  let_it_be(:reader) { Role.fetch(:reader) }

  let_it_be(:community, refind: true) { FactoryBot.create :community }

  let_it_be(:community_manager, refind: true) { FactoryBot.create :user, manager_on: [community] }

  let_it_be(:target_user, refind: true) { FactoryBot.create :user }

  let_it_be(:entity, refind: true) { FactoryBot.create :collection, community: }

  let!(:role) { reader }
  let!(:user) { target_user }

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
      expect_request! do |req|
        req.effect! change(AccessGrant, :count).by(1)

        req.data! expected_shape
      end

      expect_request! do |req|
        req.effect! keep_the_same(AccessGrant, :count)

        req.data! expected_shape
      end
    end
  end

  shared_examples_for "a failed grant" do
    let!(:expected_shape) do
      gql.mutation(:grant_access, no_errors: false) do |m|
        m[:granted] = be_blank
      end
    end

    it "does not grant the role" do
      expect_request! do |req|
        req.effect! keep_the_same(AccessGrant, :count)

        req.data! expected_shape
      end
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

  let(:empty_mutation_shape) do
    gql.empty_mutation :grant_access
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! keep_the_same(AccessGrant, :count)

        req.unauthorized!

        req.data! expected_shape
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

  as_an_admin_user do
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
    let!(:current_user) { community_manager }

    context "when granting reader access on an entity" do
      include_examples "a successful grant"
    end

    context "when granting manager access on an entity" do
      let(:role) { manager }

      include_examples "an unassignable role grant"
    end
  end

  as_a_regular_user do
    context "when granting reader access on an entity" do
      include_examples "an unauthorized mutation"
    end
  end

  as_an_anonymous_user do
    context "when revoking reader access on an entity" do
      include_examples "an unauthorized mutation"
    end
  end
end
