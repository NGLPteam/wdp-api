# frozen_string_literal: true

RSpec.describe Mutations::CreatePage, type: :request, graphql: :mutation do
  mutation_query! <<~GRAPHQL
  mutation createPage($input: CreatePageInput!) {
    createPage(input: $input) {
      page {
        title
        slug
      }

      ... ErrorFragment
    }
  }
  GRAPHQL

  let_it_be(:entity, refind: true) { FactoryBot.create :collection }

  let_it_be(:existing_page, refind: true) { FactoryBot.create :page, :existing, entity: }

  let_mutation_input!(:entity_id) { entity.to_encoded_id }
  let_mutation_input!(:title) { Faker::Lorem.sentence }
  let_mutation_input!(:slug) { title.parameterize }
  let_mutation_input!(:body) { Faker::Lorem.paragraph }

  as_an_admin_user do
    let(:expected_shape) do
      gql.mutation :create_page do |m|
        m.prop :page do |p|
          p[:title] = title
          p[:slug] = slug
        end
      end
    end

    it "creates a page" do
      expect_request! do |req|
        req.effect! change(Page, :count).by(1)

        req.data! expected_shape
      end
    end

    context "with an existing slug" do
      let_mutation_input!(:slug) { existing_page.slug }

      let(:expected_shape) do
        gql.mutation :create_page, no_errors: false do |m|
          m[:page] = be_blank

          m.attribute_errors do |ae|
            ae.error :slug, :must_be_unique_slug
          end
        end
      end

      it "fails to create the page" do
        expect_request! do |req|
          req.effect! keep_the_same(Page, :count)

          req.data! expected_shape
        end
      end
    end

    context "with an invalid slug" do
      let(:slug) { "something Invalid!" }

      let(:expected_shape) do
        gql.mutation :create_page, no_errors: false do |m|
          m[:page] = be_blank

          m.attribute_errors do |ae|
            ae.error :slug, :must_be_slug
          end
        end
      end

      it "fails to create the page" do
        expect_request! do |req|
          req.effect! keep_the_same(Page, :count)

          req.data! expected_shape
        end
      end
    end
  end
end
