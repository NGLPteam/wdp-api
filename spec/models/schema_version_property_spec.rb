# frozen_string_literal: true

RSpec.describe SchemaVersionProperty, type: :model do
  context "when a new schema version is created" do
    it "creates properties" do
      expect do
        FactoryBot.create :schema_version, :simple_collection, :v1
      end.to change(described_class, :count).by(4)
    end
  end
end
