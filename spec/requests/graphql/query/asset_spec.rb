# frozen_string_literal: true

RSpec.describe "Query.asset", type: :request do
  let!(:asset) { FactoryBot.create :asset, :pdf }

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
          downloadUrl
          kind
        }
      }
    }
    GRAPHQL
  end

  let(:expected_shape) do
    {
      asset: {
        __typename: "AssetPDF",
        name: asset.name,
        file_size: asset.file_size,
        kind: "pdf",
        content_type: asset.content_type,
        download_url: be_present,
      }
    }
  end

  context "with a processed asset" do
    before do
      perform_enqueued_jobs

      asset.reload
    end

    it "can fetch details based on the kind" do
      make_default_request!

      expect_graphql_response_data expected_shape, decamelize: true
    end
  end
end
