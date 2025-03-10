# frozen_string_literal: true

RSpec.describe Harvesting::Records::UpsertEntitiesJob, type: :job do
  include ActiveJob::TestHelper

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

    it "can upsert entities from extracted harvest entities, and then upsert assets in a separate asynchronous job" do
      expect do
        described_class.perform_now harvest_record
      end.to change(Collection, :count).by(2)
        .and change(Item, :count).by(1)
        .and change(ItemContribution, :count).by(1)
        .and have_enqueued_job(Harvesting::Entities::UpsertAssetsJob).once

      # We'll also test entity asset upsertion here because it's more effort than it's worth
      # to set up the job tests separately given that we have to repeat everything done here.

      expect do
        perform_enqueued_jobs
      end.to change(Asset, :count).by(1)
    end
  end
end
