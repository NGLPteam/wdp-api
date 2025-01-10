# frozen_string_literal: true

RSpec.describe Schemas::PropertyValues::URL do
  describe ".normalize" do
    let!(:href) { "https://example.com/foo" }

    it "handles a simple URL" do
      expect(described_class.normalize(href)).to have_attributes(href:, label: described_class::DEFAULT_LABEL)
    end

    it "handles a stringified hash with just a href" do
      hash = { href:, }.stringify_keys

      expect(described_class.normalize(hash)).to have_attributes(href:, label: described_class::DEFAULT_LABEL)
    end

    it "handles a hash" do
      label = "Test Label"

      title = "Test Title"

      hash = { href:, label:, title: }

      expect(described_class.normalize(hash)).to have_attributes(href:, label:, title:)
    end

    it "ignores junk input", :aggregate_failures do
      expect(described_class.normalize("junk")).to be_blank
      expect(described_class.normalize(nil)).to be_blank
    end
  end

  describe "#anchor_tag" do
    let!(:href) { "https://example.com/foo" }
    let!(:label) { "Test Label" }
    let!(:instance) { described_class.new(href:, label:) }

    let(:anchor_tag) { instance.anchor_tag }

    subject { anchor_tag }

    it "generates the expected HTML" do
      is_expected.to satisfy("the expected href") do |v|
        Nokogiri::HTML.fragment(v).at_css("a[href]")&.attr("href") == href
      end
    end

    context "when the label is blank" do
      let!(:label) { "" }

      it { is_expected.to be_blank }
    end
  end
end
