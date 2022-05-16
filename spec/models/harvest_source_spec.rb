# frozen_string_literal: true

RSpec.describe HarvestSource, type: :model do
  describe ".fetch!" do
    let!(:source_identifier) { "test_source" }

    let!(:harvest_source) { FactoryBot.create :harvest_source, identifier: source_identifier }

    it "can fetch a source" do
      expect(described_class.fetch!(source_identifier)).to eq harvest_source
    end

    it "raises an error when a source does not exist" do
      expect do
        described_class.fetch! "does_not_exist"
      end.to raise_error Harvesting::Sources::Unknown
    end
  end
end
