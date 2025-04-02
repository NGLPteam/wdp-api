# frozen_string_literal: true

RSpec.describe KeycloakAPI::ExecuteActionsEmail, type: :operation do
  let(:user_id) { SecureRandom.uuid }
  let(:actions) { %w[UPDATE_PASSWORD] }
  let(:client_id) { "meru-public" }
  let(:redirect_uri) { "https://admin.sandbox.meru.host/" }

  context "with an existing user" do
    before do
      Testing::Keycloak::GlobalRegistry.users.add_empty! user_id
    end

    it "succeeds with an empty response" do
      expect_calling_with(user_id, actions, client_id:, redirect_uri:).to succeed
    end
  end

  context "when the user does not exist" do
    before do
      Testing::Keycloak::GlobalRegistry.users.delete user_id
    end

    it "fails with an error" do
      expect_calling_with(user_id, actions, client_id:, redirect_uri:).to monad_fail.with_key(:request_failed)
    end
  end
end
