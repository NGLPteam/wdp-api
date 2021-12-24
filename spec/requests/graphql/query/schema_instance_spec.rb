# frozen_string_literal: true

RSpec.describe "Schema Instances", type: :request do
  let!(:article) { FactoryBot.create :item, schema: "nglp:journal_article" }

  let!(:graphql_variables) { { slug: article.system_slug } }

  let!(:query) do
    <<~GRAPHQL
    query getArticleSchemaProps($slug: Slug!) {
      article: item(slug: $slug) {
        body: schemaProperty(fullPath: "body") {
          ...PropInfoFragment
        }

        volumeId: schemaProperty(fullPath: "volume.id") {
          ... PropInfoFragment
        }

        unknown: schemaProperty(fullPath: "unknown.path") {
          ... PropInfoFragment
        }

        schemaInstanceContext {
          assets {
            kind
            label
            value
          }

          contributors {
            kind
            label
            value
          }

          entityId

          fieldValues

          schemaVersionSlug

          validity {
            valid
            errors {
              message
            }
          }
        }
      }
    }

    fragment PropInfoFragment on AnySchemaProperty {
      __typename

      ... on ScalarProperty {
        fullPath
        type
      }

      ... on StringProperty {
        content
      }

      ... on FullTextProperty {
        fullText {
          kind
          lang
          content
        }
      }
    }
    GRAPHQL
  end

  let!(:expected_shape) do
    {
      article: {
        body: {
          __typename: "FullTextProperty",
          type: "FULL_TEXT",
          full_path: "body",
          full_text: be_blank,
        },
        volume_id: {
          __typename: "StringProperty",
          type: "STRING",
          full_path: "volume.id",
          content: be_blank,
        },
        unknown: be_blank,

        schema_instance_context: {
          assets: be_blank,
          contributors: be_blank,
          entity_id: article.to_encoded_id,
          field_values: be_blank,
          schema_version_slug: article.schema_version.system_slug,
          validity: {
            valid: false,
            errors: be_present,
          }
        }
      }
    }
  end

  it "can retrieve information about incomplete schemas" do
    make_default_request!

    expect_graphql_response_data expected_shape, decamelize: true
  end
end
