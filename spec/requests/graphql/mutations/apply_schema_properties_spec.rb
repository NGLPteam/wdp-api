# frozen_string_literal: true

RSpec.describe Mutations::ApplySchemaProperties, type: :request, simple_v1_hierarchy: true, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation applySchemaProperties($input: ApplySchemaPropertiesInput!) {
    applySchemaProperties(input: $input) {
      entity {
        ... on Node { id }
      }

      collection { id }

      schemaErrors {
        base
        hint
        path
        message
        metadata
      }

      ...ErrorFragment
    }
  }
  GRAPHQL

  let!(:schema_version) { FactoryBot.create :schema_version, :required_collection }

  let!(:entity) { FactoryBot.create(:collection, schema_version: schema_version) }

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "for a collection" do
      let_mutation_input!(:entity_id) { entity.to_encoded_id }
      let_mutation_input!(:property_values) do
        { required_field: "text", optional_field: "text" }
      end

      let!(:expected_shape) do
        gql.mutation(:apply_schema_properties) do |m|
          m.prop :entity do |e|
            e[:id] = entity_id
          end

          m.prop :collection do |c|
            c[:id] = entity_id
          end

          m[:schema_errors] = be_blank
        end
      end

      context "with valid properties" do
        it "will save them" do
          expect_the_default_request.to execute_safely

          expect_graphql_data expected_shape
        end
      end

      context "with invalid properties" do
        let!(:property_values) { {} }

        let!(:expected_shape) do
          gql.mutation(:apply_schema_properties, no_errors: false) do |m|
            m[:entity] = be_blank
            m[:collection] = be_blank

            m[:schema_errors] = be_present
          end
        end

        it "will produce errors" do
          expect_the_default_request.to execute_safely

          expect_graphql_data expected_shape
        end
      end
    end
  end
end
