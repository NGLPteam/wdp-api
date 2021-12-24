# frozen_string_literal: true

RSpec.describe SchemaDefinition, type: :model do
  specify "the factory upserts without issue" do
    expect do
      FactoryBot.create :schema_definition, :simple_collection
      FactoryBot.create :schema_definition, :simple_collection
    end.to execute_safely.and change(described_class, :count).by(1)
  end
end
