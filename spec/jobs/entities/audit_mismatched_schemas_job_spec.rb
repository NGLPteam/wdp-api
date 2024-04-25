# frozen_string_literal: true

RSpec.describe Entities::AuditMismatchedSchemasJob, type: :job do
  let!(:collection) { FactoryBot.create :collection, schema: "nglp:series" }
  let!(:synced_entity) { collection.entity }

  let!(:default_collection) { SchemaVersion["default:collection"] }

  before do
    synced_entity.schema_version = default_collection

    synced_entity.save!
  end

  it "corrects the discrepancy" do
    expect do
      described_class.perform_now
    end.to(
      change(Audits::MismatchedEntitySchema, :count).by(-1)
    .and(
      change { synced_entity.reload.schema_version }.from(default_collection).to(collection.schema_version)
    )
    )
  end
end
