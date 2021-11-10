# frozen_string_literal: true

RSpec.shared_examples_for "an entity with schematic properties" do |var_name|
  let!(:entity) { public_send(var_name) }

  context "when reading properties" do
    it "serializes without issue" do
      expect do
        entity.read_property_context.field_values
      end.not_to raise_error
    end
  end
end
