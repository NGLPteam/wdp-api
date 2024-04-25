# frozen_string_literal: true

RSpec.shared_context "applies schema properties" do
  let(:entity_id) { nil }
  let(:property_values) do
    {}
  end

  let(:mutation_input) do
    { entity_id:, property_values: }
  end

  let(:graphql_variables) { { input: mutation_input } }

  let(:query) do
    Rails.root.join("spec", "support", "graphql", "apply_schema_properties.graphql").read
  end
end
