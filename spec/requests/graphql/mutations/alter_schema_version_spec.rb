# frozen_string_literal: true

RSpec.describe Mutations::AlterSchemaVersion, type: :request, simple_v1_hierarchy: true, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation alterSchemaVersion($input: AlterSchemaVersionInput!) {
    alterSchemaVersion(input: $input) {
      entity {
        ... on Node { id }

        ... on Entity {
          schemaVersion { id }
        }
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

  def change_both_schema_versions
    (
      change { entity.reload.schema_version }.from(schema_version).to(changed_version)
    ).and(
      change { synced_entity.reload.schema_version }.from(schema_version).to(changed_version)
    )
  end

  def keep_both_schema_versions_the_same
    (
      keep_the_same { entity.reload.schema_version }
    ).and(
      keep_the_same { synced_entity.reload.schema_version }
    )
  end

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:collection) { create_v1_collection }

    context "for an entity" do
      let!(:schema_version) { SchemaVersion.default_item }

      let!(:entity) { FactoryBot.create(:item, collection: collection, schema_version: schema_version) }

      let!(:synced_entity) { entity.entity }

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

      shared_examples_for "a valid alteration" do
        let(:changed_version) { SchemaVersion[schema_version_slug] }

        let(:expected_shape) do
          gql.mutation(:alter_schema_version) do |m|
            m.prop :entity do |e|
              e[:id] = entity_id

              e.prop :schema_version do |sv|
                sv[:id] = changed_version.to_encoded_id
              end
            end

            m[:schema_errors] = be_blank
          end
        end

        it "updates the schema version" do
          expect_the_default_request.to change_both_schema_versions

          expect_graphql_data expected_shape
        end
      end

      context "when applying against a schema with no required properties" do
        let!(:schema_version) { SchemaVersion.default_collection }

        let!(:entity) { FactoryBot.create :collection }

        let_mutation_input!(:schema_version_slug) { "nglp:series" }

        let_mutation_input!(:property_values) { {} }

        it_behaves_like "a valid alteration"
      end

      context "with valid properties" do
        it_behaves_like "a valid alteration"
      end

      context "with an invalid slug" do
        let!(:schema_version_slug) { "nglp:doesnotexist" }

        let!(:expected_shape) do
          gql.mutation(:alter_schema_version, no_errors: false) do |m|
            m[:entity] = be_blank
            m[:errors] = be_present
            m[:schema_errors] = be_blank
          end
        end

        it "sends an error the client" do
          expect_the_default_request.to keep_both_schema_versions_the_same

          expect_graphql_data expected_shape
        end
      end

      context "with invalid properties" do
        let!(:schema_version_slug) { "nglp:journal_article" }

        let!(:property_values) { {} }

        let!(:expected_shape) do
          gql.mutation(:alter_schema_version, no_errors: false) do |m|
            m[:entity] = be_blank
            m[:errors] = be_present
            m[:schema_errors] = be_blank
          end
        end

        it "will produce errors" do
          expect_the_default_request.to keep_both_schema_versions_the_same

          expect_graphql_data expected_shape
        end
      end

      context "when skipping property application" do
        let!(:property_values) { {} }

        let!(:strategy) { "SKIP" }

        it_behaves_like "a valid alteration"
      end
    end
  end
end
