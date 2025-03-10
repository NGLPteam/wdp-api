# frozen_string_literal: true

RSpec.describe HarvestSource, type: :model do
  let_it_be(:valid_harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

  let_it_be(:broken_harvest_source, refind: true) { FactoryBot.create :harvest_source, :broken_oai }

  specify "creating a new, valid harvest source should mark itself active and asynchronously fetch sets" do
    expect do
      new_harvest_source = FactoryBot.create(:harvest_source, :oai, :jats)

      expect(new_harvest_source).to be_active
    end.to have_enqueued_job(::Harvesting::Sources::ExtractSetsJob).once
  end

  describe "#check" do
    context "with a valid harvest source" do
      before do
        valid_harvest_source.update_column(:status, "inactive")
      end

      it "can check the harvest source" do
        expect do
          expect(valid_harvest_source.check).to succeed
        end.to change(valid_harvest_source, :checked_at)
          .and change(valid_harvest_source, :status).from("inactive").to("active")
      end
    end

    context "with an invalid harvest source" do
      before do
        broken_harvest_source.update_column(:status, "active")
      end

      it "can check the harvest source" do
        expect do
          expect(broken_harvest_source.check).to succeed
        end.to change(broken_harvest_source, :checked_at)
          .and change(broken_harvest_source, :status).from("active").to("inactive")
      end
    end
  end

  describe "#extract_sets" do
    context "with a valid harvest source" do
      it "extracts sets synchronously" do
        expect do
          expect(valid_harvest_source.extract_sets).to succeed
        end.to change(HarvestSet, :count).by(::Harvesting::Testing::OAI::Set.count)
      end
    end

    context "with an invalid harvest source" do
      it "succeeds but logs an error and harvests no sets" do
        expect do
          expect(broken_harvest_source.extract_sets).to succeed
        end.to keep_the_same(HarvestSet, :count)
          .and change(HarvestMessage.fatal, :count).by(1)
      end
    end
  end

  describe "#upsert_set" do
    it "can upsert a set directly without extracting" do
      expect do
        expect(broken_harvest_source.upsert_set("foo-bar")).to succeed
      end.to change(HarvestSet, :count).by(1)
    end
  end

  describe ".fetch!" do
    let_it_be(:source_identifier) { "test_source" }

    let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, identifier: source_identifier }

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
