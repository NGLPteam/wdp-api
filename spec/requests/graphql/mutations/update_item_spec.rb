# frozen_string_literal: true

RSpec.describe Mutations::UpdateItem, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:item) { FactoryBot.create :item, :with_thumbnail, title: old_title }

    let!(:old_title) { Faker::Lorem.unique.sentence }

    let!(:new_title) { Faker::Lorem.unique.sentence }

    let(:old_visibility) { item.visibility.upcase }
    let(:new_visibility) { old_visibility }

    let(:visible_after_at) { nil }
    let(:visible_until_at) { nil }

    let(:new_thumbnail) { nil }
    let(:clear_thumbnail) { false }

    let!(:mutation_input) do
      {
        itemId: item.to_encoded_id,
        title: new_title,
        visibility: new_visibility,
        visible_after_at: visible_after_at,
        visible_until_at: visible_until_at,
        thumbnail: new_thumbnail,
        clear_thumbnail: clear_thumbnail,
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input
      }
    end

    let!(:expected_shape) do
      {
        updateItem: {
          item: {
            title: new_title,
            visibility: new_visibility,
          }
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updateItem($input: UpdateItemInput!) {
        updateItem(input: $input) {
          item {
            title
            visibility
            visibleAfterAt
            visibleUntilAt
          }

          attributeErrors {
            path
            messages
          }
        }
      }
      GRAPHQL
    end

    it "updates a item" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to change { item.reload.title }.from(old_title).to(new_title)

      expect_graphql_response_data expected_shape
    end

    context "with a blank title" do
      let(:new_title) { "" }

      let!(:expected_shape) do
        {
          updateItem: {
            item: be_blank,
            attributeErrors: [
              { path: "title", messages: ["must be filled"] },
            ]
          }
        }
      end

      it "fails to update the item" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to keep_the_same { item.reload.title }

        expect_graphql_response_data expected_shape
      end
    end

    context "when clearing a thumbnail" do
      let!(:clear_thumbnail) { true }

      it "removes the thumbnail" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change { item.reload.thumbnail.present? }.from(true).to(false)
      end

      context "with a new upload" do
        let!(:new_thumbnail) do
          graphql_upload_from "spec", "data", "lorempixel.jpg"
        end

        let!(:expected_shape) do
          {
            updateItem: {
              item: be_blank,
              attributeErrors: [
                {
                  path: "thumbnail",
                  messages: [
                    I18n.t("dry_validation.errors.update_and_clear_attachment")
                  ]
                },
              ]
            }
          }
        end

        it "fails to change anything" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to keep_the_same { item.reload.thumbnail.id }

          expect_graphql_response_data expected_shape
        end
      end
    end

    context "when hiding" do
      let(:new_visibility) { "HIDDEN" }

      it "hides the item and updates the timestamp" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to change { item.reload.visibility }.from("visible").to("hidden").and(
          change { item.reload.hidden_at.present? }.from(false).to(true)
        )
      end
    end

    context "when setting a limited visibility" do
      let(:new_visibility) { "LIMITED" }

      context "with a valid range" do
        let(:visible_after_at) { 1.day.ago.iso8601 }
        let(:visible_until_at) { 1.day.from_now.iso8601 }

        let!(:expected_shape) do
          {
            updateItem: {
              item: {
                visibility: "LIMITED",
                visibleAfterAt: be_present,
                visibleUntilAt: be_present,
              },
              attributeErrors: be_blank
            }
          }
        end

        it "updates the visibility" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to change { item.reload.visibility }.from("visible").to("limited")

          expect_graphql_response_data expected_shape
        end
      end

      context "with an inverted range" do
        let(:visible_until_at) { 1.day.ago.iso8601 }
        let(:visible_after_at) { 1.day.from_now.iso8601 }

        let!(:expected_shape) do
          {
            updateItem: {
              item: be_blank,
              attributeErrors: [
                {
                  path: "visibleUntilAt",
                  messages: [
                    I18n.t("dry_validation.errors.limited_visibility_inverted_range")
                  ],
                },
              ]
            }
          }
        end

        it "fails to update the visibility" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to keep_the_same { item.reload.visibility }

          expect_graphql_response_data expected_shape
        end
      end

      context "with an empty range" do
        let!(:expected_shape) do
          {
            updateItem: {
              item: be_blank,
              attributeErrors: [
                {
                  path: "visibility",
                  messages: [
                    I18n.t("dry_validation.errors.limited_visibility_requires_range")
                  ],
                },
                {
                  path: "visibleAfterAt",
                  messages: [
                    I18n.t("dry_validation.errors.range_required_when_limited_visibility")
                  ]
                },
                {
                  path: "visibleUntilAt",
                  messages: [
                    I18n.t("dry_validation.errors.range_required_when_limited_visibility")
                  ]
                },
              ]
            }
          }
        end

        it "fails to update the visibility" do
          expect do
            make_graphql_request! query, token: token, variables: graphql_variables
          end.to keep_the_same { item.reload.visibility }

          expect_graphql_response_data expected_shape
        end
      end
    end
  end
end
