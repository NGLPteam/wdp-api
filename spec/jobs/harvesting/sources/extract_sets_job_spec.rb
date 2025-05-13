# frozen_string_literal: true

RSpec.describe Harvesting::Sources::ExtractSetsJob, type: :job do
  context "with a valid, working OAI-PMH JATS source" do
    let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

    it "extracts sets" do
      expect do
        described_class.perform_now harvest_source
      end.to change(HarvestSet, :count).by(2)
    end
  end

  context "with a broken OAI-PMH source" do
    let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :broken_oai }

    it "logs a fatal error" do
      expect do
        described_class.perform_now harvest_source
      end.to keep_the_same(HarvestSet, :count)
        .and change(HarvestMessage.fatal, :count).by(1)
    end
  end
end
