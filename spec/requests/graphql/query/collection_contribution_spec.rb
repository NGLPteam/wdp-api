# frozen_string_literal: true

RSpec.describe "Query.collectionContribution", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getCollectionContribution($slug: Slug!) {
      collectionContribution(slug: $slug) {
        slug
      }
    }
    GRAPHQL
  end

  as_an_admin_user do
    context "with a valid slug" do
      let!(:graphql_variables) { { slug: collection_contribution.system_slug } }

      let!(:collection_contribution) { FactoryBot.create :collection_contribution }

      let(:expected_shape) do
        gql.query do |q|
          q.prop :collection_contribution do |cc|
            cc[:slug] = collection_contribution.system_slug
          end
        end
      end

      it "has the right value" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end

    context "with an invalid slug" do
      let!(:graphql_variables) { { slug: random_slug } }

      let(:expected_shape) do
        gql.query do |q|
          q[:collection_contribution] = be_blank
        end
      end

      it "returns nil" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end
  end
end
