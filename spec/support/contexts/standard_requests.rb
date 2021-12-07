# frozen_string_literal: true

require_relative "../token_helper"

RSpec.shared_context "standard requests" do
  let(:token) { nil }
  let(:accept) { nil }
  let(:authorization) { "Bearer #{token}" if token.present? }
  let(:request_headers) do
    {}.tap do |h|
      h["ACCEPT"] = accept if accept.present?
      h["AUTHORIZATION"] = authorization if authorization.present?
    end
  end

  # @abstract
  def make_request!(*)
    raise "Must define how to make the request here"
  end

  def safely_make_request!(...)
    expect do
      make_request!(...)
    end.to execute_safely
  end

  def server_message(key, scope: "server_messages")
    I18n.t(key, scope: "server_messages.tokens")
  end

  def render_server_message(key, scope: "server_messages")
    include_json(
      errors: [
        { message: server_message(key, scope: scope) }
      ]
    )
  end
end
