# frozen_string_literal: true

RSpec.describe Mutations::UpdateCollection, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation updateCollection($input: UpdateCollectionInput!) {
    updateCollection(input: $input) {
      collection {
        title
        visibility
        visibleAfterAt
        visibleUntilAt
      }

      schemaErrors {
        base
        hint
        path
        message
        metadata
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let(:schema_version) { SchemaVersion["default:collection"] }

    let!(:collection) { FactoryBot.create :collection, :with_thumbnail, schema: schema_version, title: old_title }

    let!(:old_title) { Faker::Lorem.unique.sentence }

    let!(:new_title) { Faker::Lorem.unique.sentence }

    let(:old_visibility) { collection.visibility.upcase }
    let(:new_visibility) { old_visibility }

    let(:new_thumbnail) { nil }

    let_mutation_input!(:collection_id) { collection.to_encoded_id }
    let_mutation_input!(:title) { new_title }
    let_mutation_input!(:visibility) { new_visibility }
    let_mutation_input!(:visible_after_at) { nil }
    let_mutation_input!(:visible_until_at) { nil }
    let_mutation_input!(:thumbnail) { new_thumbnail }
    let_mutation_input!(:clear_thumbnail) { false }

    let!(:expected_shape) do
      gql.mutation(:update_collection, schema: true) do |m|
        m.prop :collection do |c|
          c[:title] = new_title
          c[:visibility] = new_visibility
        end
      end
    end

    it "updates a collection" do
      expect_the_default_request.to change { collection.reload.title }.from(old_title).to(new_title)

      expect_graphql_data expected_shape
    end

    context "with a blank title" do
      let(:new_title) { "" }

      let!(:expected_shape) do
        gql.mutation :update_collection, schema: true, no_errors: false do |m|
          m[:collection] = be_blank

          m.errors do |e|
            e.error :title, :filled?
          end
        end
      end

      it "fails to update the collection" do
        expect_the_default_request.to keep_the_same { collection.reload.title }

        expect_graphql_data expected_shape
      end
    end

    context "when applying schema properties" do
      mutation_query! <<~GRAPHQL
      mutation updateCollection($input: UpdateCollectionInput!) {
        updateCollection(input: $input) {
          collection {
            title
            visibility
            visibleAfterAt
            visibleUntilAt

            requiredField: schemaProperty(fullPath: "required_field") {
              ... on StringProperty {
                content
              }
            }
          }

          schemaErrors {
            base
            hint
            path
            message
            metadata
          }

          ... ErrorFragment
        }
      }
      GRAPHQL

      let(:schema_version) { FactoryBot.create :schema_version, :required_collection, :v1 }

      let(:required_field) { nil }
      let(:optional_field) { nil }

      let!(:expected_shape) do
        gql.mutation :update_collection, schema: true do |m|
          m.prop :collection do |c|
            c[:title] = new_title

            c.prop :required_field do |rf|
              rf[:content] = required_field
            end
          end
        end
      end

      let_mutation_input!(:schema_properties) do
        {
          required_field: required_field,
          optional_field: optional_field,
        }
      end

      context "with valid schema properties" do
        let(:required_field) { "Some Required Text" }

        it "updates the collection" do
          expect_the_default_request.to change { collection.reload.read_property_value!("required_field") }.to(required_field)

          expect_graphql_data expected_shape
        end
      end

      context "with an invalid schema field" do
        let!(:expected_shape) do
          gql.mutation :update_collection, schema: true, no_errors: true, no_schema_errors: false do |m|
            m[:collection] = be_blank

            m.schema_errors do |se|
              se.error "required_field", :filled?
            end
          end
        end

        it "does not update the collection" do
          expect_the_default_request.to keep_the_same { collection.reload.title }

          expect_graphql_data expected_shape
        end
      end
    end

    context "when clearing a thumbnail" do
      let!(:clear_thumbnail) { true }

      it "removes the thumbnail" do
        expect_the_default_request.to change { collection.reload.thumbnail.present? }.from(true).to(false)
      end

      context "with a new upload" do
        let!(:new_thumbnail) do
          graphql_upload_from "spec", "data", "lorempixel.jpg"
        end

        let!(:expected_shape) do
          gql.mutation :update_collection, schema: true, no_errors: false do |m|
            m[:collection] = be_blank

            m.errors do |e|
              e.error :thumbnail, :update_and_clear_attachment
            end
          end
        end

        it "fails to change anything" do
          expect_the_default_request.to keep_the_same { collection.reload.thumbnail.id }

          expect_graphql_data expected_shape
        end
      end
    end

    context "when hiding" do
      let(:new_visibility) { "HIDDEN" }

      it "hides the collection and updates the timestamp" do
        expect_the_default_request.to change { collection.reload.visibility }.from("visible").to("hidden").and(
          change { collection.reload.hidden_at.present? }.from(false).to(true)
        )
      end
    end

    context "when setting a limited visibility" do
      let(:new_visibility) { "LIMITED" }

      context "with a valid range" do
        let(:visible_after_at) { 1.day.ago.iso8601 }
        let(:visible_until_at) { 1.day.from_now.iso8601 }

        let!(:expected_shape) do
          gql.mutation :update_collection, schema: true do |m|
            m.prop :collection do |c|
              c[:title] = new_title
              c[:visibility] = new_visibility
              c[:visible_after_at] = be_present
              c[:visible_until_at] = be_present
            end
          end
        end

        it "updates the visibility" do
          expect_the_default_request.to change { collection.reload.visibility }.from("visible").to("limited")

          expect_graphql_data expected_shape
        end
      end

      context "with an inverted range" do
        let(:visible_until_at) { 1.day.ago.iso8601 }
        let(:visible_after_at) { 1.day.from_now.iso8601 }

        let!(:expected_shape) do
          gql.mutation :update_collection, schema: true, no_errors: false do |m|
            m[:collection] = be_blank

            m.errors do |e|
              e.error :visibleUntilAt, :limited_visibility_inverted_range
            end
          end
        end

        it "fails to update the visibility" do
          expect_the_default_request.to keep_the_same { collection.reload.visibility }

          expect_graphql_data expected_shape
        end
      end

      context "with an empty range" do
        let!(:expected_shape) do
          gql.mutation :update_collection, schema: true, no_errors: false do |m|
            m[:collection] = be_blank

            m.errors do |e|
              e.error :visibility, :limited_visibility_requires_range
              e.error :visibleAfterAt, :range_required_when_limited_visibility
              e.error :visibleUntilAt, :range_required_when_limited_visibility
            end
          end
        end

        it "fails to update the visibility" do
          expect_the_default_request.to keep_the_same { collection.reload.visibility }

          expect_graphql_data expected_shape
        end
      end
    end
  end
end
