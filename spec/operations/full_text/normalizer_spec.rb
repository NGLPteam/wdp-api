# frozen_string_literal: true

RSpec.describe FullText::Normalizer, type: :operation do
  let!(:operation) { described_class.new }

  let(:input) { nil }

  context "with a full-text reference" do
    let(:kind) { :text }
    let(:lang) { nil }
    let(:content) { nil }

    let(:reference) { { kind: kind, lang: lang, content: content } }

    let(:input) { reference }

    it "stringifies nil values" do
      expect_calling_with(input).to eq reference.transform_values(&:to_s)
    end

    context "when the kind is from GraphQL" do
      let(:kind) { "HTML" }

      it "handles converting it properly" do
        expect_calling_with(input).to include_json kind: "html"
      end
    end

    context "when the kind is unknown" do
      let(:kind) { "something unknown" }

      it "falls back to assuming raw text" do
        expect_calling_with(input).to include_json kind: "text"
      end
    end
  end

  context "with a blank string" do
    let(:content) { "some random content" }

    let(:input) { content }

    it "turns it into a reference" do
      expect_calling_with(input).to include_json kind: "text", content: content
    end
  end
end
