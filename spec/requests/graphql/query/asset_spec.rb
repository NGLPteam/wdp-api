# frozen_string_literal: true

RSpec.describe "Query.asset", type: :request do
  let_it_be(:asset, refind: true) do
    perform_enqueued_jobs do
      FactoryBot.create :asset, :pdf
    end
  end

  let(:graphql_variables) { { slug: asset.system_slug } }

  let(:query) do
    <<~GRAPHQL
    query getAsset($slug: Slug!) {
      asset(slug: $slug) {
        __typename

        ... on AssetPDF {
          name
          caption
          fileSize
          contentType
          # Deprecated, but test that it still works.
          old_url: downloadUrl
          downloadURL
          kind
        }
      }
    }
    GRAPHQL
  end

  let(:expected_shape) do
    gql.query do |q|
      q.prop :asset do |ast|
        ast.typename("AssetPDF")

        ast[:name] = asset.name
        ast[:file_size] = asset.file_size
        ast[:kind] = "pdf"
        ast[:content_type] = asset.content_type
        ast[:old_url] = be_present
        ast[:download_url] = be_present
      end
    end
  end

  context "with a processed asset" do
    it "can fetch details based on the kind" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end
end
