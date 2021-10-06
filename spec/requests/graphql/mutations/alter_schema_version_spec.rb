# frozen_string_literal: true

RSpec.describe Mutations::AlterSchemaVersion, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "for an item" do
      let!(:schema_version) { SchemaVersion.default_item }

      let!(:entity) { FactoryBot.create(:item, schema_version: schema_version) }

      let!(:schema_version_slug) do
        "nglp:article:latest"
      end

      let!(:strategy) { "APPLY" }

      let!(:property_values) do
        FactoryBot.create_list :contributor, 5, :person

        WDPAPI::Container["schemas.static.generate.nglp.article"].call
      end

      let!(:mutation_input) do
        {
          entityId: entity.to_encoded_id,
          schemaVersionSlug: schema_version_slug,
          propertyValues: property_values,
          strategy: strategy,
        }
      end

      let!(:graphql_variables) do
        {
          input: mutation_input
        }
      end

      let!(:query) do
        <<~GRAPHQL
        mutation alterSchemaVersion($input: AlterSchemaVersionInput!) {
          alterSchemaVersion(input: $input) {
            entity {
              ... on Node { id }
            }

            item {
              id

              schemaVersion { id }
            }

            schemaErrors {
              base
              hint
              path
              message
              metadata
            }

            errors {
              message
            }
          }
        }
        GRAPHQL
      end

      context "with valid properties" do
        let!(:article_version) { SchemaVersion[schema_version_slug] }

        let!(:expected_shape) do
          {
            alterSchemaVersion: {
              entity: { id: entity.to_encoded_id },
              item: {
                id: entity.to_encoded_id,
                schemaVersion: { id: article_version.to_encoded_id }
              },
              schemaErrors: be_blank
            }
          }
        end

        it "will save them" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to execute_safely

          expect_graphql_response_data expected_shape
        end
      end

      context "with an invalid slug" do
        let!(:schema_version_slug) { "nglp:doesnotexist" }

        let!(:expected_shape) do
          {
            alterSchemaVersion: {
              entity: be_blank,
              item: be_blank,
              errors: be_present,
              schemaErrors: be_blank,
            }
          }
        end

        it "sends an error the client" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to execute_safely

          expect_graphql_response_data expected_shape
        end
      end

      context "with invalid properties" do
        let!(:property_values) { {} }

        let!(:expected_shape) do
          {
            alterSchemaVersion: {
              entity: be_blank,
              item: be_blank,
              schemaErrors: be_present,
            }
          }
        end

        it "will produce errors" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to execute_safely

          expect_graphql_response_data expected_shape
        end
      end

      context "when skipping property application" do
        let!(:property_values) { {} }

        let!(:strategy) { "SKIP" }

        let!(:article_version) { SchemaVersion[schema_version_slug] }

        let!(:expected_shape) do
          {
            alterSchemaVersion: {
              entity: { id: entity.to_encoded_id },
              item: {
                id: entity.to_encoded_id,
                schemaVersion: { id: article_version.to_encoded_id }
              },
              schemaErrors: be_blank
            }
          }
        end

        it "will alter the version without altering properties" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to change { entity.reload.schema_version.system_slug }.from(schema_version.system_slug).to(article_version.system_slug)

          expect_graphql_response_data expected_shape
        end
      end
    end
  end
end
