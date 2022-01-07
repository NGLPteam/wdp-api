# frozen_string_literal: true

RSpec.describe SchemaVersionOrdering, type: :model do
  let!(:schema_version) { FactoryBot.create :schema_version, :simple_collection, :v1 }

  it "extracts the expected amount of records" do
    expect(schema_version.schema_version_orderings.count).to eq 2
  end
end
