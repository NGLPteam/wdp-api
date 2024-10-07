# frozen_string_literal: true

RSpec.describe Assets::DecodeDownloadToken, type: :operation do
  let_it_be(:asset, refind: true) { FactoryBot.create :asset }

  let!(:token) { MeruAPI::Container["assets.encode_download_token"].(asset, expires_at: 2.weeks.ago).value! }

  it "decodes regardless of the expiration date" do
    expect_calling_with(asset, token).to succeed.with(true)
  end
end
