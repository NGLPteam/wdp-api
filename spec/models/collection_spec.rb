# frozen_string_literal: true

RSpec.describe Collection, type: :model do
  let!(:collection) { FactoryBot.create :collection }

  it_behaves_like "an entity with a reference"
  it_behaves_like "an entity with schematic properties", :collection
  it_behaves_like "an entity with schematic references", :collection

  context "when creating a collection" do
    context "with a schema that defines orderings" do
      let!(:simple_collection_v1) { FactoryBot.create :schema_version, :simple_collection, :v1 }

      it "creates the orderings defined in the schema" do
        expect do
          FactoryBot.create :collection, schema_version: simple_collection_v1
        end.to change(described_class, :count).by(1).and change(Ordering, :count).by(2)
      end
    end
  end
end
