# frozen_string_literal: true

RSpec.describe FullText::ExtractTextContent, type: :operation do
  let!(:operation) { described_class.new }

  it "returns nil with an unknown content type" do
    expect_calling_with(kind: "anything else", content: "some content").to be_nil
  end

  context "with kind = 'text'" do
    it "returns nil with a bunch of whitespace" do
      expect_calling_with(kind: "text", content: "   \t \n \n \n").to be_nil
    end

    it "strips and squishes extra white space" do
      expect_calling_with(kind: "text", content: "\tthis\nis   some text    ").to eq "this is some text"
    end
  end

  context "with kind = 'html'" do
    it "extracts text from the HTML" do
      content = <<~HTML
      <h1>Some Title</h1>
      <p>Some content</p><br />
      HTML

      expect_calling_with(kind: "html", content: content).to eq "Some Title Some content"
    end

    it "returns nil when there is no text content" do
      expect_calling_with(kind: "html", content: "<br />").to be_nil
    end

    it "returns nil with empty content" do
      expect_calling_with(kind: "html", content: "").to be_nil
    end
  end

  context "with kind = 'markdown'" do
    it "extracts text from the markdown" do
      content = <<~MARKDOWN
      # Some Title

      Some content
      MARKDOWN

      expect_calling_with(kind: "markdown", content: content).to eq "Some Title Some content"
    end

    it "returns nil with empty content" do
      expect_calling_with(kind: "markdown", content: "").to be_nil
    end
  end
end
