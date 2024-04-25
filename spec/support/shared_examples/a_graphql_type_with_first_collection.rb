# frozen_string_literal: true

RSpec.shared_examples_for "a graphql type with firstCollection" do
  subject { raise "set the subject" }

  let(:parent) { subject }
  let(:parent_key) do
    case parent
    when Collection then :parent
    when Community then :community
    else
      raise "parent is not an collection, set parent_key"
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

  describe "#firstCollection" do
    let!(:custom_schema) { FactoryBot.create :schema_version, :collection }

    let!(:subcollection_with_custom_schema) { FactoryBot.create :collection, title: "Schema", schema_version: custom_schema, parent_key => parent }
    let!(:subcollection_a) { FactoryBot.create :collection, title: ?A, parent_key => parent }
    let!(:subcollection_z) { FactoryBot.create :collection, title: ?Z, parent_key => parent }

    let(:graphql_variables) { { slug: subject.system_slug, schema: [custom_schema.system_slug] } }

    let!(:query) do
      <<~GRAPHQL
      query getFirstCollections($slug: Slug!, $schema: [String!]) {
        subject: #{subject_field}(slug: $slug) {
          custom: firstCollection(schema: $schema) {
            id
          }

          z: firstCollection(order: TITLE_DESCENDING) {
            id
          }
        }
      }
      GRAPHQL
    end

    let(:expected_shape) do
      gql.query do |q|
        q.prop :subject do |sub|
          sub.prop :custom do |c|
            c[:id] = subcollection_with_custom_schema.to_encoded_id
          end

          sub.prop :z do |z|
            z[:id] = subcollection_z.to_encoded_id
          end
        end
      end
    end

    it "can fetch collections by various filters and orderings" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end
end
