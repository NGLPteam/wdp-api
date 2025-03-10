# frozen_string_literal: true

RSpec.describe HarvestRecord, type: :model do
  let_it_be(:source_identifier) { "test_source" }
  let_it_be(:record_identifier) { "test_record" }

  let_it_be(:harvest_source) { FactoryBot.create :harvest_source, identifier: source_identifier }
  let_it_be(:harvest_record) { FactoryBot.create :harvest_record, harvest_source:, identifier: record_identifier }

  describe "#build_extraction_context" do
    context "with no configuration" do
      it "raises an error" do
        expect do
          harvest_record.build_extraction_context
        end.to raise_error Harvesting::Records::NoConfiguration
      end
    end
  end

  describe ".fetch_for_source" do
    it "fetches an existing record" do
      expect(described_class.fetch_for_source(source_identifier, record_identifier)).to eq harvest_record
    end

    it "returns nil if nothing found" do
      expect(described_class.fetch_for_source(source_identifier, "does_not_exist")).to be_nil
    end
  end

  describe ".fetch_for_source!" do
    it "fetches an existing record" do
      expect(described_class.fetch_for_source!(source_identifier, record_identifier)).to eq harvest_record
    end

    it "raises an exception if nothing found" do
      expect do
        described_class.fetch_for_source!(source_identifier, "does_not_exist")
      end.to raise_error Harvesting::Records::Unknown, /does_not_exist/
    end
  end
end
