# frozen_string_literal: true

RSpec.describe Assets::ParseKind, type: :operation do
  let!(:operation) { described_class.new }

  let!(:asset) { FactoryBot.create :asset }

  let!(:uploaded_file) { asset.attachment }

  context "with an image attachment" do
    let!(:asset) { FactoryBot.create :asset, :image }

    specify do
      expect_calling_with(uploaded_file).to succeed.with "image"
    end
  end

  context "with an audio attachment" do
    let!(:asset) { FactoryBot.create :asset, :audio }

    specify do
      expect_calling_with(uploaded_file).to succeed.with "audio"
    end
  end

  context "with a PDF attachment" do
    let!(:asset) { FactoryBot.create :asset, :pdf }

    specify do
      expect_calling_with(uploaded_file).to succeed.with "pdf"
    end
  end

  context "with a video attachment" do
    let!(:asset) { FactoryBot.create :asset, :video }

    specify do
      expect_calling_with(uploaded_file).to succeed.with "video"
    end
  end

  context "with a document attachment" do
    let!(:asset) { FactoryBot.create :asset, :document }

    specify do
      expect_calling_with(uploaded_file).to succeed.with "document"
    end
  end

  it "returns unknown with nil" do
    expect_calling_with(nil).to succeed.with("unknown")
  end
end
