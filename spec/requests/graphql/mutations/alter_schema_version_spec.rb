# frozen_string_literal: true

RSpec.describe Mutations::AlterSchemaVersion, type: :request, simple_v1_hierarchy: true, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation alterSchemaVersion($input: AlterSchemaVersionInput!) {
    alterSchemaVersion(input: $input) {
      entity {
        ... on Node { id }
      }

      item {
        id

        schemaVersion { id }
      }

      ... ErrorFragment

      errors { message }

      schemaErrors {
        base
        hint
        path
        message
        metadata
      }
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:collection) { create_v1_collection }

    context "for an item" do
      let!(:schema_version) { SchemaVersion.default_item }

      let!(:entity) { FactoryBot.create(:item, collection: collection, schema_version: schema_version) }

      let!(:strategy) { "APPLY" }

      let_mutation_input!(:entity_id) { entity.to_encoded_id }
      let_mutation_input!(:schema_version_slug) { simple_item_v1.declaration }
      let_mutation_input!(:strategy) { "APPLY" }
      let_mutation_input!(:property_values) do
        {
          foo: "Foo",
          bar: {
            baz: "Baz"
          },
          sequence: "Seq"
        }
      end

      let(:valid_shape) do
        gql.mutation(:alter_schema_version) do |m|
          m.prop :entity do |e|
            e[:id] = entity_id
          end

          m.prop :item do |i|
            i[:id] = entity_id

            i.prop :schema_version do |sv|
              sv[:id] = changed_version.to_encoded_id
            end
          end

          m[:schema_errors] = be_blank
        end
      end

      context "with valid properties" do
        let!(:changed_version) { SchemaVersion[schema_version_slug] }

        let!(:expected_shape) do
          valid_shape
        end

        it "will save them" do
          expect_the_default_request.to execute_safely

          expect_graphql_data expected_shape
        end
      end

      context "with an invalid slug" do
        let!(:schema_version_slug) { "nglp:doesnotexist" }

        let!(:expected_shape) do
          gql.mutation(:alter_schema_version, no_errors: false) do |m|
            m[:entity] = be_blank
            m[:item] = be_blank
            m[:errors] = be_present
            m[:schema_errors] = be_blank
          end
        end

        it "sends an error the client" do
          expect_the_default_request.to execute_safely

          expect_graphql_data expected_shape
        end
      end

      context "with invalid properties" do
        let!(:schema_version_slug) { "nglp:journal_article" }

        let!(:property_values) { {} }

        let!(:expected_shape) do
          gql.mutation(:alter_schema_version, no_errors: false) do |m|
            m[:entity] = be_blank
            m[:item] = be_blank
            m[:errors] = be_present
            m[:schema_errors] = be_blank
          end
        end

        it "will produce errors" do
          expect_the_default_request.to execute_safely

          expect_graphql_data expected_shape
        end
      end

      context "when skipping property application" do
        let!(:property_values) { {} }

        let!(:strategy) { "SKIP" }

        let!(:changed_version) { SchemaVersion[schema_version_slug] }

        let!(:expected_shape) do
          valid_shape
        end

        it "will alter the version without altering properties" do
          expect_the_default_request.to change { entity.reload.schema_version.system_slug }.from(schema_version.system_slug).to(changed_version.system_slug)

          expect_graphql_data expected_shape
        end
      end
    end
  end
end
