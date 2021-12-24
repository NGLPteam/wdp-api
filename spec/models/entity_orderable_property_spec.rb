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
end
