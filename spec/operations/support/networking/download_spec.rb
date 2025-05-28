# frozen_string_literal: true

RSpec.describe ::Support::Networking::Download, type: :operation do
  include_context "misbehaving SSL upstream"

  let_it_be(:base_url) { "https://example.com/test.pdf" }

  context "when dealing with a regular timeout" do
    before do
      stub_request(:get, base_url).to_timeout
    end

    it "raises an error immediately" do
      expect do
        expect_calling_with(base_url)
      end.to raise_error Down::TimeoutError
    end
  end

  context "when dealing with a misbehaving SSL upstream" do
    let(:failure_count) { 2 }
    let(:retries) { 3 }
    let(:sleep) { 0 }

    before do
      stub_request(:get, base_url).
        to_raise(misbehaving_ssl_exception).times(failure_count).then.
        to_return(
          body: proc { Rails.root.join("spec", "data", "sample.pdf").open("r+") },
          headers: {
            "Content-Type": "application/pdf",
          }
        )
    end

    context "when it fails an acceptable number of times" do
      let(:failure_count) { 2 }

      it "handles the failures gracefully" do
        expect do
          expect_calling_with(base_url, retries:, sleep:).to be_a_kind_of(Tempfile)
        end.to execute_safely
      end
    end

    context "when it fails an unacceptable number of times" do
      let(:failure_count) { retries + 1 }

      it "raises an error that Shrine knows how to handle" do
        expect do
          expect_calling_with(base_url, retries:, sleep:)
        end.to raise_error ::Shrine::Plugins::RemoteUrl::DownloadError
      end
    end
  end
end
