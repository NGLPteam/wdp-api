# frozen_string_literal: true

RSpec.describe RelatedCollectionLink, type: :model do
  let!(:test_schema) { FactoryBot.create :schema_version, :collection }
  let!(:other_schema) { FactoryBot.create :schema_version, :collection }

  let!(:source_collection) { FactoryBot.create :collection, schema_version: test_schema }
  let!(:target_collection) { FactoryBot.create :collection, schema_version: test_schema }
  let!(:other_collection) { FactoryBot.create :collection, schema_version: other_schema }

  it "exposes only linked collections with the same schema version" do
    expect do
      FactoryBot.create :entity_link, source: source_collection, target: target_collection
      FactoryBot.create :entity_link, source: source_collection, target: other_collection
    end.to change { source_collection.entity_links.count }.by(2).and change { source_collection.related_collections.count }.by(1)

    expect(source_collection.related_collections).to include target_collection
  end
end
