# frozen_string_literal: true

RSpec.describe ::Support::Networking::MisbehavingSSLUpstream::Error do
  include_context "misbehaving SSL upstream"

  describe ".maybe_wrap_and_reraise!" do
    it "wraps the right exception correctly" do
      expect do
        described_class.maybe_wrap_and_reraise!(misbehaving_ssl_exception)
      end.to raise_error described_class
    end

    it "can wrap nested errors caused by another" do
      expect do
        begin
          raise misbehaving_ssl_exception
        rescue StandardError
          raise "wrapping error"
        end
      rescue RuntimeError => e
        described_class.maybe_wrap_and_reraise!(e)
      end.to raise_error described_class
    end

    it "allows other errors to pass through unchanged" do
      expect do
        raise "problem"
      rescue RuntimeError => e
        described_class.maybe_wrap_and_reraise!(e)
      end.to raise_error RuntimeError
    end
  end
end
