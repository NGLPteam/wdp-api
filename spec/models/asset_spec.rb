# frozen_string_literal: true

RSpec.describe Asset, type: :model do
  context "with processed attachments" do
    let!(:asset_trait) { :image }
    let!(:asset) do
      FactoryBot.create :asset, asset_trait
    end

    subject { asset }

    context "with an audio asset" do
      let!(:asset_trait) { :audio }

      it { is_expected.to be_audio }
    end

    context "with a document asset" do
      let!(:asset_trait) { :document }

      it { is_expected.to be_document }
    end

    context "with an image asset" do
      let!(:asset_trait) { :image }

      it { is_expected.to be_image }
    end

    context "with a PDF asset" do
      let!(:asset_trait) { :pdf }

      it { is_expected.to be_pdf }
    end

    context "with a video asset" do
      let!(:asset_trait) { :video }

      it { is_expected.to be_video }
    end

    it "can destroy an asset properly" do
      expect do
        asset.destroy
      end.to execute_safely.and change(described_class, :count).by(-1)
    end
  end
end
