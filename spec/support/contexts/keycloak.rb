# frozen_string_literal: true

RSpec.shared_context "with mocked keycloak" do
  let_it_be(:token_helper) { TestingAPI::TestContainer["tokens.helper"] }
end

RSpec.configure do |config|
  config.include_context "with mocked keycloak", type: :request
end
