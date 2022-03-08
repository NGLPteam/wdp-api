# frozen_string_literal: true

RSpec.describe EntityOrderableProperty, type: :model do
  context "when saving an entity" do
    let!(:schema) { FactoryBot.create :schema_version, :simple_collection }

    let!(:entity) { FactoryBot.create :collection, schema: "default:collection" }

    let!(:new_properties) do
      {
        foo: "Foo Value",
        bar: {
          baz: "Baz Value"
        },
        sequence: ?1
      }
    end

    it "creates a number of properties" do
      expect do
        entity.alter_version!(schema, new_properties).value!
      end.to execute_safely.and change(described_class, :count).by(3)
    end
  end

  describe ".value_column_for_type" do
    column_mappings = EntityOrderableProperty::SUPPORTED_PROPERTY_TYPES.index_with do |type|
      :"#{type}_value"
    end

    column_mappings.each do |type, column|
      it "returns the right value for #{type.inspect}" do
        expect(described_class.value_column_for_type(type)).to eq(column)
      end
    end

    it "returns the raw value for a blank type" do
      expect(described_class.value_column_for_type(nil)).to eq :raw_value
    end

    it "returns the raw value for an unknown or unsupported type" do
      expect(described_class.value_column_for_type(:anything_else)).to eq :raw_value
    end
  end
end
