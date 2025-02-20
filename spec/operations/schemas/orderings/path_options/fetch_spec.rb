# frozen_string_literal: true

RSpec.describe Schemas::Orderings::PathOptions::Fetch, type: :operation do
  let!(:schemas) { [] }

  let!(:expected_schemas) do
    MeruAPI::Container["schemas.associations.find_all_matching_versions"].(Schemas::Orderings::Types::OrderingFilters[schemas]).value!
  end

  let!(:expected_ancestors) do
    if schemas.present?
      MeruAPI::Container["schemas.associations.find_unique_ancestors"].(expected_schemas).value!
    else
      []
    end
  end

  let!(:total_schema_property_count) { SchemaVersionProperty.orderable.count }
  let!(:total_static_property_count) { StaticOrderableProperty.visible.count }

  let(:expected_schema_property_count) do
    if schemas.present?
      expected_schemas.sum do |version|
        SchemaVersionProperty.orderable.filtered_by_schema_version(version).count
      end
    else
      total_schema_property_count
    end
  end

  let!(:expected_static_property_count) { total_static_property_count }

  let!(:expected_ancestor_schema_property_count) do
    expected_ancestors.sum do |anc|
      SchemaVersionProperty.orderable.filtered_by_schema_version(anc.target_version).count
    end
  end

  let!(:expected_ancestor_static_property_count) do
    expected_ancestors.count * total_static_property_count
  end

  let!(:expected_property_count) do
    expected_schema_property_count + expected_static_property_count + expected_ancestor_schema_property_count + expected_ancestor_static_property_count
  end

  let!(:operation_args) do
    { schemas: }
  end

  matcher :have_the_expected_property_count do
    match do |actual|
      @actual = actual.value!.size

      values_match? expected_property_count, @actual
    end

    failure_message do |actual|
      "expected that the result would have #{expected_property_count} #{'property'.pluralize(expected_property_count)}, got #{@actual}"
    end
  end

  shared_examples_for "a valid set of args" do
    it "has the expected count of properties" do
      expect_calling_with(**operation_args).to have_the_expected_property_count
    end
  end

  context "with no args" do
    include_examples "a valid set of args"
  end

  context "with a schema specified" do
    let!(:simple_collection) { FactoryBot.create :schema_version, :simple_collection, :v1 }

    let(:schemas) do
      [
        simple_collection.slice(:namespace, :identifier)
      ]
    end

    include_examples "a valid set of args"
  end

  context "with an unknown schema specified" do
    let(:schemas) do
      [
        { namespace: "unknown", identifier: "schema" }
      ]
    end

    it "has no schema properties in the result" do
      expect_calling_with(**operation_args).to have_the_expected_property_count
    end
  end
end
