# frozen_string_literal: true

RSpec.describe SchemaVersion, type: :model do
  describe "operation fire tests" do
    let!(:schema_version) { FactoryBot.create :schema_version, :simple_collection }

    describe "#read_property_context" do
      it "works as expected" do
        expect(schema_version.read_property_context).to be_a_kind_of Schemas::Properties::Context
      end
    end

    describe "#read_properties" do
      it "works as expected" do
        be_a_reader = satisfy("a reader") { |r| r.kind_of?(Schemas::Properties::Reader) || r.kind_of?(Schemas::Properties::GroupReader) }

        expect(schema_version.read_properties).to succeed.with all(be_a_reader)
      end
    end
  end

  specify "the factory upserts without issue" do
    expect do
      FactoryBot.create :schema_version, :simple_collection
      FactoryBot.create :schema_version, :simple_collection
    end.to execute_safely.and change(described_class, :count).by(1)
  end

  context "when triggering a reorder because of a new version" do
    let!(:schema_definition) { FactoryBot.create :schema_definition, :for_item }

    let!(:version_1) { FactoryBot.create :schema_version, :item, schema_definition:, number: "1.0.0" }
    let!(:version_2) { FactoryBot.create :schema_version, :item, schema_definition:, number: "2.0.0" }

    specify "creating a new version will reorder the definition's versions" do
      expect do
        @version_3 = FactoryBot.create :schema_version, :item, schema_definition:, number: "3.0.0"
      end.to execute_safely.and keep_the_same { version_1.reload.current }.
        and change { version_2.reload.current }.from(true).to(false)
    end
  end
end
