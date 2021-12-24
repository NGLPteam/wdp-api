# frozen_string_literal: true

RSpec.describe SchemaDefinitionProperty, type: :model do
  context "when a new schema version is created" do
    it "updates the materialized view" do
      expect do
        FactoryBot.create :schema_version, :simple_collection, :v1
      end.to change(described_class, :count).by(4)
    end

    context "with previous versions" do
      let!(:previous_version) { FactoryBot.create :schema_version, :simple_item, :v1 }

      it "picks up on the new properties, if any" do
        expect do
          FactoryBot.create :schema_version, :simple_item, :v2
        end.to change(described_class, :count).by(1)
      end
    end
  end

  context "when a schema has multiple versions" do
    let!(:definition) { FactoryBot.create :schema_definition, :simple_item }
    let!(:v1) { FactoryBot.create :schema_version, :simple_item, :v1 }
    let!(:v2) { FactoryBot.create :schema_version, :simple_item, :v2 }

    let!(:shared_property) { described_class.fetch definition, "foo" }

    context "with property found only in one version" do
      let!(:property) { described_class.fetch definition, "bar.quux" }

      subject { property }

      it "covers only one version" do
        expect(property).to have_attributes(covered_version_ids: [v2.id])
      end
    end

    context "with a property that spans versions" do
      let!(:property) { described_class.fetch definition, "foo" }

      it "has a reference to each version" do
        expect(property.covered_version_ids).to contain_exactly v1.id, v2.id
      end
    end
  end
end
