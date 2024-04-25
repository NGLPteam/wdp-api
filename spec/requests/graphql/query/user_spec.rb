# frozen_string_literal: true

RSpec.describe "Query.user", type: :request do
  let!(:query) do
    <<~GRAPHQL
    query getUser($slug: Slug!) {
      user(slug: $slug) {
        name
        slug
        avatar {
          small {
            webp {
              url
            }
          }
        }
      }
    }
    GRAPHQL
  end

  let_it_be(:existing_user, refind: true) { FactoryBot.create :user, :with_avatar }

  as_an_admin_user do
    context "with a valid slug" do
      let(:slug) { existing_user.system_slug }

      let!(:graphql_variables) { { slug:, } }

      let(:expected_shape) do
        gql.query do |q|
          q.prop :user do |u|
            u[:name] = existing_user.name
            u[:slug] = slug
          end
        end
      end

      it "has the right shape" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end

    context "with an invalid slug" do
      let!(:graphql_variables) { { slug: random_slug } }

      let(:expected_shape) do
        gql.query do |q|
          q[:user] = be_blank
        end
      end

      it "finds nothing" do
        expect_request! do |req|
          req.data! expected_shape
        end
      end
    end
  end
end
