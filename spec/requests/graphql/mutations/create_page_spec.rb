# frozen_string_literal: true

RSpec.describe Mutations::CreatePage, type: :request do
  context "as an admin" do
    let(:token) { token_helper.build_token has_global_admin: true }

    let!(:entity) { FactoryBot.create :collection }

    let!(:title) { Faker::Lorem.sentence }
    let!(:slug) { title.parameterize }
    let!(:body) { Faker::Lorem.paragraph }

    let!(:mutation_input) do
      {
        entityId: entity.to_encoded_id,
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
        createPage: {
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
      mutation createPage($input: CreatePageInput!) {
        createPage(input: $input) {
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
      end.to change(Page, :count).by(1)

      expect_graphql_response_data expected_shape
    end

    context "with an existing slug" do
      let!(:existing_page) { FactoryBot.create :page, :existing, entity: entity }

      let!(:slug) { existing_page.slug }

      let(:expected_shape) do
        {
          createPage: {
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
        end.to keep_the_same(Page, :count)

        expect_graphql_response_data expected_shape
      end
    end

    context "with an invalid slug" do
      let(:slug) { "something Invalid!" }

      let(:expected_shape) do
        {
          createPage: {
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
        end.to keep_the_same(Page, :count)

        expect_graphql_response_data expected_shape
      end
    end
  end
end
