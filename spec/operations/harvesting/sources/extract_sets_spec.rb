# frozen_string_literal: true

RSpec.describe Harvesting::Sources::ExtractSets, type: :operation do
  context "with a valid, working OAI-PMH JATS source" do
    let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

    it "extracts sets" do
      expect do
        expect_calling_with(harvest_source).to succeed
      end.to change(HarvestSet, :count).by(2)
    end
  end

  context "with a broken OAI-PMH source" do
    let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :broken_oai }

    it "logs a fatal error" do
      expect do
        expect_calling_with(harvest_source).to succeed
      end.to keep_the_same(HarvestSet, :count)
        .and change(HarvestMessage.fatal, :count).by(1)
    end
  end
end
