# frozen_string_literal: true

RSpec.describe "Identity introspection", type: :request do
  include_context "standard requests"

  describe "GET /whoami" do
    let(:user) { FactoryBot.create :user }

    def make_request!(*)
      get identity_path, headers: request_headers
    end

    def render_token_error(key)
      render_server_message(key, scope: "server_messages.tokens")
    end

    shared_examples_for "an anonymous request" do
      it "says we are anonymous" do
        safely_make_request!

        expect(response).to be_json_content

        expect(response).to be_successful

        expect(response.parsed_body).to include_json(anonymous: true)
      end
    end

    shared_examples_for "an authenticated request" do
      it "says we are who we say we are" do
        safely_make_request!

        expect(response).to be_json_content

        expect(response).to be_successful

        expect(response.parsed_body).to include_json(anonymous: false, name: user.name)
      end
    end

    context "with no token" do
      include_examples "an anonymous request"
    end

    context "with a blank token" do
      let(:authorization) { "Bearer " }

      include_examples "an anonymous request"
    end

    context "with a user token" do
      let!(:token) { token_helper.build_token from_user: user }

      include_examples "an authenticated request"
    end

    context "with an expired token" do
      let!(:token) { token_helper.build_token issued_at: 2.hours.ago, expires_at: 1.hour.ago }

      it "is unauthorized" do
        safely_make_request!

        expect(response).to be_json_content

        expect(response).to have_http_status :unauthorized

        expect(response.parsed_body).to render_token_error(:expired)
      end
    end

    context "with junk data in the token" do
      let!(:authorization) { "Bearer 1238193821989" }

      it "is forbidden" do
        safely_make_request!

        expect(response).to be_json_content

        expect(response).to have_http_status :forbidden

        expect(response.parsed_body).to render_token_error(:invalid)
      end
    end
  end
end
