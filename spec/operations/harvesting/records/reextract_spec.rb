# frozen_string_literal: true

RSpec.describe Harvesting::Records::Reextract, type: :operation do
  let_it_be(:target_entity, refind: true) { FactoryBot.create :collection, :journal }

  let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

  let_it_be(:harvest_configuration, refind: true) { harvest_source.create_configuration!(target_entity:) }

  let_it_be(:sample_record) { Harvesting::Testing::OAI::JATSRecord.find("1576") }

  let_it_be(:harvest_record, refind: true) do
    FactoryBot.create(
      :harvest_record,
      harvest_source:,
      harvest_configuration:,
      sample_record:
    )
  end

  context "with a valid JATS record" do
    before do
      harvest_record.extract_entities!
    end

    it "works" do
      expect_calling_with(harvest_record).to succeed
    end
  end
end
