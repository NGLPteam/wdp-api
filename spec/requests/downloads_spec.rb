# frozen_string_literal: true

RSpec.describe "Downloads Controller", type: :request do
  include_context "standard requests"

  describe "GET /downloads/:id?token=:token" do
    let_it_be(:existing_asset, refind: true) { FactoryBot.create :asset }

    let(:id) { existing_asset.system_slug }
    let(:token) { nil }

    def make_request!
      get download_path(id, token:)
    end

    context "with a valid token" do
      let(:token) { existing_asset.download_token }

      it "redirects to a download url" do
        safely_make_request!

        expect(response).to redirect_to existing_asset.actual_download_url
        expect(response).to have_http_status :see_other
      end
    end

    context "with a missing token" do
      let(:token) { "" }

      it "is unauthorized" do
        safely_make_request!

        expect(response).to have_http_status :unauthorized
      end
    end

    context "with a garbage token" do
      let(:token) { "does not work" }

      it "is a bad request" do
        safely_make_request!

        expect(response).to have_http_status :bad_request
      end
    end

    context "with a missing asset" do
      let(:id) { SecureRandom.uuid }

      it "is not found" do
        safely_make_request!

        expect(response).to have_http_status :not_found
      end
    end
  end
end
