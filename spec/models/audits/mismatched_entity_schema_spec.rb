# frozen_string_literal: true

RSpec.describe Audits::MismatchedEntitySchema, type: :model do
  let!(:collection) { FactoryBot.create :collection, schema: "nglp:series" }
  let!(:synced_entity) { collection.entity }

  it "detects out of sync entities" do
    expect do
      synced_entity.schema_version = SchemaVersion["default:collection"]

      synced_entity.save!
    end.to change(described_class, :count).by(1)
  end
end
