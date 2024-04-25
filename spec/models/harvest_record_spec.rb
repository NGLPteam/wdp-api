# frozen_string_literal: true

RSpec.describe HarvestRecord, type: :model do
  context "with an existing record" do
    let(:source_identifier) { "test_source" }
    let(:record_identifier) { "test_record" }
    let!(:harvest_source) { FactoryBot.create :harvest_source, identifier: source_identifier }
    let!(:harvest_attempt) { FactoryBot.create :harvest_attempt, harvest_source: }
    let!(:harvest_record) { FactoryBot.create :harvest_record, harvest_attempt:, identifier: record_identifier }

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
end
