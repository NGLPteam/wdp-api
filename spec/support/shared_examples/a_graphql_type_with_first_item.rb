# frozen_string_literal: true

RSpec.shared_examples_for "a graphql type with firstItem" do
  subject { raise "set the subject" }

  let(:parent) { subject }
  let(:parent_key) do
    case parent
    when Collection then :collection
    when Item then :parent
    else
      raise "parent is not an item, set parent_key"
    end
  end

  let(:subject_field) do
    case subject
    when Collection then :collection
    when Community then :community
    when Item then :item
    else
      raise "set the subject_field: the field on QueryType that resolves to our subject"
    end
  end

  describe "#firstItem" do
    let!(:custom_schema) { FactoryBot.create :schema_version, :item }

    let!(:subitem_with_custom_schema) { FactoryBot.create :item, title: "Schema", schema_version: custom_schema, parent_key => parent }
    let!(:subitem_a) { FactoryBot.create :item, title: ?A, parent_key => parent }
    let!(:subitem_z) { FactoryBot.create :item, title: ?Z, parent_key => parent }

    let(:graphql_variables) { { slug: subject.system_slug, schema: [custom_schema.system_slug] } }

    let!(:query) do
      <<~GRAPHQL
      query getFirstItems($slug: Slug!, $schema: [String!]) {
        subject: #{subject_field}(slug: $slug) {
          custom: firstItem(schema: $schema) {
            id
          }

          z: firstItem(order: TITLE_DESCENDING) {
            id
          }
        }
      }
      GRAPHQL
    end

    let(:expected_shape) do
      {
        subject: {
          custom: { id: subitem_with_custom_schema.to_encoded_id },
          z: { id: subitem_z.to_encoded_id },
        },
      }
    end

    it "can fetch items by various filters and orderings" do
      make_default_request!

      expect_graphql_response_data expected_shape, decamelize: true
    end
  end
end
