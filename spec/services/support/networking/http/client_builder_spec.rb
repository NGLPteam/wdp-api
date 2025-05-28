# frozen_string_literal: true

RSpec.describe ::Support::Networking::HTTP::ClientBuilder do
  include_context "misbehaving SSL upstream"

  let_it_be(:base_url) { "https://example.com/test" }

  let_it_be(:max_retries) { 3 }

  let_it_be(:retry_backoff_factor) { 1 }

  let_it_be(:retry_interval) { 0.1 }
  let_it_be(:retry_interval_randomness) { 0 }

  let(:retry_block) do
    object_double(proc {}, call: true).as_null_object.tap do |dbl|
      allow(dbl).to receive(:call).and_return(nil)
    end
  end

  let(:client) do
    described_class.new(
      base_url,
      max_retries:,
      retry_backoff_factor:,
      retry_block:,
      retry_interval:,
      retry_interval_randomness:,
    ).call.value!
  end

  def expect_making_the_request
    expect(client.get(base_url))
  end

  context "when dealing with a misbehaving SSL upstream" do
    let(:failure_count) { 2 }
    let(:sleep) { 0 }

    before do
      stub_request(:get, base_url).
        to_raise(misbehaving_ssl_exception).times(failure_count).then.
        to_return(
          body: "test content",
          headers: {
            "Content-Type": "text/plain",
          }
        )
    end

    context "when it fails an acceptable number of times" do
      let(:failure_count) { 2 }

      it "handles the failures gracefully" do
        expect do
          expect_making_the_request.to be_a_kind_of(Faraday::Response)
        end.to execute_safely

        expect(retry_block).to have_received(:call).exactly(failure_count).times
      end
    end

    context "when it fails an unacceptable number of times" do
      let(:failure_count) { max_retries + 1 }

      it "raises an error based on Faraday's SSL error" do
        expect do
          expect_making_the_request
        end.to raise_error ::Support::Networking::MisbehavingSSLUpstream::Error

        expect(retry_block).to have_received(:call).exactly(max_retries).times
      end
    end
  end
end
