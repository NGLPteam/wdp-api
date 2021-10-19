# frozen_string_literal: true

RSpec.describe Mutations::UpdatePage, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:entity) { FactoryBot.create :collection }

    let!(:page) { FactoryBot.create :page, :with_hero_image, entity: entity }

    let!(:title) { Faker::Lorem.sentence }
    let!(:slug) { title.parameterize }
    let!(:body) { Faker::Lorem.paragraph }

    let!(:mutation_input) do
      {
        pageId: page.to_encoded_id,
        title: title,
        slug: slug,
        body: body
      }
    end

    let!(:graphql_variables) do
      {
        input: mutation_input,
      }
    end

    let!(:expected_shape) do
      {
        updatePage: {
          page: {
            title: title,
            slug: slug
          },
          attributeErrors: be_blank,
          globalErrors: be_blank,
        }
      }
    end

    let!(:query) do
      <<~GRAPHQL
      mutation updatePage($input: UpdatePageInput!) {
        updatePage(input: $input) {
          page {
            title
            slug
          }

          attributeErrors {
            messages
            path
            type
          }

          globalErrors {
            message
          }
        }
      }
      GRAPHQL
    end

    it "creates a page" do
      expect do
        make_graphql_request! query, token: token, variables: graphql_variables
      end.to execute_safely

      expect_graphql_response_data expected_shape
    end

    context "with an existing slug" do
      let!(:existing_page) { FactoryBot.create :page, :existing, entity: entity }

      let!(:slug) { existing_page.slug }

      let(:expected_shape) do
        {
          updatePage: {
            page: be_blank,
            attributeErrors: [
              {
                path: "slug",
                messages: [
                  I18n.t("dry_validation.errors.must_be_unique_slug")
                ]
              }
            ],
            globalErrors: be_blank,
          },
        }
      end

      it "fails to create the page" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to execute_safely

        expect_graphql_response_data expected_shape
      end
    end

    context "with an invalid slug" do
      let(:slug) { "something Invalid!" }

      let(:expected_shape) do
        {
          updatePage: {
            page: be_blank,
            attributeErrors: [
              {
                path: "slug",
                messages: [
                  I18n.t("dry_validation.errors.must_be_slug")
                ]
              }
            ],
            globalErrors: be_blank,
          },
        }
      end

      it "fails to create the page" do
        expect do
          make_graphql_request! query, token: token, variables: graphql_variables
        end.to execute_safely

        expect_graphql_response_data expected_shape
      end
    end
  end
end
