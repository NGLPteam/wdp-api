# frozen_string_literal: true

RSpec.describe Mutations::UserResetPassword, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation UserResetPassword($input: UserResetPasswordInput!) {
    userResetPassword(input: $input) {
      success

      user {
        email
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:existing_user, refind: true) { FactoryBot.create :user }
  let_it_be(:missing_user, refind: true) { FactoryBot.create :user, :unknown_in_keycloak }

  let_mutation_input!(:user_id) { nil }
  let_mutation_input!(:client_id) { "meru-public" }
  let_mutation_input!(:location) { "ADMIN" }
  let_mutation_input!(:redirect_path) { ?/ }

  let(:expected_user) { current_user }

  let(:valid_mutation_shape) do
    gql.mutation(:user_reset_password) do |m|
      m[:success] = true

      m.prop :user do |u|
        u[:email] = expected_user.email
      end
    end
  end

  let(:empty_mutation_shape) do
    gql.empty_mutation :user_reset_password
  end

  before do
    Testing::Keycloak::GlobalRegistry.users.add_existing! existing_user
    Testing::Keycloak::GlobalRegistry.users.remove_existing! missing_user
  end

  shared_examples_for "a successful mutation" do
    let(:expected_shape) { valid_mutation_shape }

    it "sends a password reset email for the user" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  shared_examples_for "an unauthorized mutation" do
    let(:expected_shape) { empty_mutation_shape }

    it "is not authorized" do
      expect_request! do |req|
        req.effect! execute_safely

        req.unauthorized!

        req.data! expected_shape
      end
    end
  end

  as_an_admin_user do
    context "when the user is unspecified" do
      let(:expected_user) { current_user }

      it_behaves_like "a successful mutation"
    end

    context "when specifying another existing user" do
      let_mutation_input!(:user_id) { existing_user.to_encoded_id }

      let(:expected_user) { existing_user }

      it_behaves_like "a successful mutation"
    end

    context "when specifying a user that is not found in keycloak anymore" do
      let_mutation_input!(:user_id) { missing_user.to_encoded_id }

      let(:expected_shape) do
        gql.mutation(:user_reset_password, no_errors: false) do |m|
          m[:success] = be_blank
          m[:user] = be_blank

          m.global_errors do |ge|
            ge.error(/Keycloak:/)
          end
        end
      end

      it "does not trigger an email action" do
        expect_request! do |req|
          req.effect! execute_safely

          req.data! expected_shape
        end
      end
    end
  end

  as_a_regular_user do
    context "when the user is unspecified" do
      it_behaves_like "a successful mutation"
    end

    context "when specifying another existing user" do
      let_mutation_input!(:user_id) { existing_user.to_encoded_id }

      it_behaves_like "an unauthorized mutation"
    end
  end

  as_an_anonymous_user do
    context "when the user is unspecified" do
      it_behaves_like "an unauthorized mutation"
    end

    context "when specifying another existing user" do
      let_mutation_input!(:user_id) { existing_user.to_encoded_id }

      it_behaves_like "an unauthorized mutation"
    end
  end
end
