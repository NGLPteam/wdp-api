# frozen_string_literal: true

RSpec.describe Harvesting::Records::PruneEntities, type: :operation do
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
    ).tap do |hr|
      perform_enqueued_jobs do
        hr.extract_entities!
        hr.upsert_entities!
      end
    end
  end

  let!(:volume) { actual_entity_for("volume-1") }
  let!(:issue) { actual_entity_for("issue-1") }
  let!(:article) { actual_entity_for("meru:oai:jats:1576") }

  def actual_entity_for(identifier)
    harvest_record.harvest_entities.where(identifier:).first!.reload_entity
  end

  context "when an entity has been modified" do
    before do
      issue.update!(harvest_modification_status: "modified")
    end

    it "can selectively prune entities when mode=unmodified" do
      expect do
        expect_calling_with(harvest_record, mode: "unmodified").to succeed.with(skipped: 2, pruned: 1)
      end.to execute_safely
        .and change(HarvestEntity, :count).by(-1)
        .and change(Item, :count).by(-1)
        .and change(ItemContribution, :count).by(-1)
        .and keep_the_same(Collection, :count)
    end

    it "can ignore modifications when mode=everything" do
      expect do
        expect_calling_with(harvest_record, mode: "everything").to succeed.with(skipped: 0, pruned: 3)
      end.to execute_safely
        .and change(HarvestEntity, :count).by(-3)
        .and change(Item, :count).by(-1)
        .and change(ItemContribution, :count).by(-1)
        .and change(Collection, :count).by(-2)
    end
  end
end
