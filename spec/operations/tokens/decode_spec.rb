# frozen_string_literal: true

RSpec.describe Tokens::Decode, type: :operation do
  let!(:encoder) { Tokens::Encode.new }

  let!(:audience) { "token_audience" }

  let!(:sub) { "token_sub" }

  let!(:payload) { { "aud" => audience, "some" => "data", "sub" => sub } }

  let(:encoded_token) { encode! payload }

  def encode!(payload)
    encoder.call(payload).value!
  end

  it "decodes an encoded token" do
    result = operation.call encoded_token

    expect(result).to be_a_success

    expect(result.value!).to eq payload
  end

  it "balks at a foreign token" do
    random_jwk = JWT::JWK.new OpenSSL::PKey::RSA.generate 2048

    encoded_token = JWT.encode payload, random_jwk.keypair, "RS512", { kid: random_jwk.kid }

    result = operation.call encoded_token

    expect(result).to be_a_failure
  end

  it "fails with a blank token" do
    expect(operation.call("")).to be_a_failure
  end

  it "fails with an invalid token" do
    expect(operation.call("this is not a valid JWT")).to be_a_failure
  end

  context "when dealing with expirations" do
    let!(:payload) { { "some" => "data", "exp" => 1.week.ago.to_i } }

    it "handles expired tokens" do
      expect_calling_with(encoded_token).to monad_fail.with_key(:expired)
    end

    it "can ignore expirations" do
      expect_calling_with(encoded_token, verify_expiration: false).to succeed.with(payload)
    end
  end

  context "when verifying an audience" do
    it "checks the audience for validity" do
      result = operation.call encoded_token, aud: audience

      expect(result).to be_a_success
    end

    it "fails with an invalid audience" do
      result = operation.call encoded_token, aud: "something_else"

      expect(result).to be_a_failure
    end
  end

  context "when verifying a token subject" do
    it "checks the subject for validity" do
      result = operation.call(encoded_token, sub:)

      expect(result).to be_a_success
    end

    it "fails with an invalid subject" do
      result = operation.call encoded_token, sub: "something_else"

      expect(result).to be_a_failure
    end
  end
end
