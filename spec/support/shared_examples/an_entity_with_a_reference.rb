# frozen_string_literal: true

RSpec.shared_examples_for "an entity with a reference" do
  let(:source_entity_factory) { described_class.default_factory }
  let(:source_entity) { FactoryBot.create source_entity_factory }

  specify "creating a real model creates an Entity" do
    expect do
      FactoryBot.create(source_entity_factory)
    end.to change(Entity.where(entity_type: described_class.name), :count).by(1)
  end

  specify "the generated entity has the correct type" do
    expect(source_entity.schema_kind).to eq source_entity.entity.schema_kind
  end
end
