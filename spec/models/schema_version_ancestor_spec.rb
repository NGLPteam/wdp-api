# frozen_string_literal: true

RSpec.describe SchemaVersionAncestor, type: :model do
  context "when a new schema version is created" do
    let!(:community_ancestor) { FactoryBot.create :schema_version, :simple_community, :v1 }

    it "creates ancestors" do
      expect do
        FactoryBot.create :schema_version, :simple_collection, :v1
      end.to change(described_class, :count).by(1)
    end
  end
end
