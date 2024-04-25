# frozen_string_literal: true

RSpec.describe "Query.itemContribution", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getItemContribution($slug: Slug!) {
      itemContribution(slug: $slug) {
        slug
      }
    }
    GRAPHQL
  end

  as_an_admin_user do
    context "with a valid slug" do
      let!(:graphql_variables) { { slug: item_contribution.system_slug } }

      let!(:item_contribution) { FactoryBot.create :item_contribution }

      let(:expected_shape) do
        gql.query do |q|
          q.prop :item_contribution do |cc|
            cc[:slug] = item_contribution.system_slug
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
          q[:item_contribution] = be_blank
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
