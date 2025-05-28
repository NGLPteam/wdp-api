# frozen_string_literal: true

RSpec.describe ::Support::Networking::HTTP::BuildClient, type: :operation do
  include_context "misbehaving SSL upstream"

  let_it_be(:base_url) { "https://example.com/test.html" }

  it "can build an HTTP client" do
    expect do
      expect_calling_with(base_url, allow_insecure: true).to succeed.with(a_kind_of(::Faraday::Connection))
    end
  end
end
