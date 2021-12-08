# frozen_string_literal: true

RSpec.describe RelatedItemLink, type: :model do
  let!(:test_schema) { FactoryBot.create :schema_version, :item }
  let!(:other_schema) { FactoryBot.create :schema_version, :item }

  let!(:source_item) { FactoryBot.create :item, schema_version: test_schema }
  let!(:target_item) { FactoryBot.create :item, schema_version: test_schema }
  let!(:other_item) { FactoryBot.create :item, schema_version: other_schema }

  it "exposes only linked items with the same schema version" do
    expect do
      FactoryBot.create :entity_link, source: source_item, target: target_item
      FactoryBot.create :entity_link, source: source_item, target: other_item
    end.to change { source_item.entity_links.count }.by(2).and change { source_item.related_items.count }.by(1)

    expect(source_item.related_items).to include target_item
  end
end
