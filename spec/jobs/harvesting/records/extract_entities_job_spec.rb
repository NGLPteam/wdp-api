# frozen_string_literal: true

RSpec.describe Harvesting::Records::ExtractEntitiesJob, type: :job do
  let_it_be(:target_entity, refind: true) { FactoryBot.create :collection, :journal }

  let_it_be(:harvest_source, refind: true) { FactoryBot.create :harvest_source, :oai, :jats }

  let_it_be(:harvest_configuration, refind: true) { harvest_source.create_configuration!(target_entity:) }

  let_it_be(:sample_record) { Harvesting::Testing::OAI::JATSRecord.find("1576") }

  let_it_be(:harvest_record, refind: true) do
    FactoryBot.create(
      :harvest_record,
      :pending,
      harvest_source:,
      harvest_configuration:,
      sample_record:
    )
  end

  context "with a valid JATS record" do
    it "can extract harvest entities" do
      expect do
        described_class.perform_now harvest_record
      end.to have_enqueued_job(Harvesting::Records::UpsertEntitiesJob).once
        .and change { harvest_record.reload.status }.from("pending").to("active")
        .and change(HarvestEntity, :count).by(3)
        .and change(HarvestContribution, :count).by(1)
        .and change(HarvestContributor, :count).by(1)
        .and change(Contributor, :count).by(1)
    end
  end
end
