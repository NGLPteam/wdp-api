# frozen_string_literal: true

RSpec.describe Mutations::ApplySchemaProperties, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    context "for an item" do
      let!(:schema_version) { SchemaVersion.by_tuple("nglp", "article").latest! }

      let!(:entity) { FactoryBot.create(:item, schema_version: schema_version) }

      let!(:property_values) do
        FactoryBot.create_list :contributor, 5, :person

        WDPAPI::Container["schemas.static.generate.nglp.article"].call
      end

      let!(:mutation_input) do
        {
          entityId: entity.to_encoded_id,
          propertyValues: property_values,
        }
      end

      let!(:graphql_variables) do
        {
          input: mutation_input
        }
      end

      let!(:expected_shape) do
        {
          applySchemaProperties: {
            entity: { id: entity.to_encoded_id },
            item: { id: entity.to_encoded_id },
            schemaErrors: be_blank
          }
        }
      end

      let!(:query) do
        <<~GRAPHQL
        mutation applySchemaProperties($input: ApplySchemaPropertiesInput!) {
          applySchemaProperties(input: $input) {
            entity {
              ... on Node { id }
            }

            item { id }

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
      end

      context "with valid properties" do
        it "will save them" do
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
            applySchemaProperties: {
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
    end
  end
end
