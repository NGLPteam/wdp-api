# frozen_string_literal: true

RSpec.describe "ImageAttachment", type: :request do
  let!(:item) { FactoryBot.create :item }
  let!(:graphql_variables) { { slug: item.system_slug } }

  let(:operation_name) { "getItem" }

  let!(:query) do
    <<~GRAPHQL
    query getItem($slug: Slug!) {
      item(slug: $slug) {
        heroImage {
          ...AttachmentInfoFragment
        }
        thumbnail {
          ...AttachmentInfoFragment
        }
        heroImageMetadata {
          alt
        }
        thumbnailMetadata {
          alt
        }
      }
    }

    fragment AttachmentInfoFragment on ImageAttachment {
      alt
      storage
      metadata {
        alt
      }
      original {
        ...ImageInfoFragment
      }
      large {
        ...SizeInfoFragment
      }
      medium {
        ...SizeInfoFragment
      }
      small {
        ...SizeInfoFragment
      }
      thumb {
        ...SizeInfoFragment
      }
    }

    fragment SizeInfoFragment on ImageSize {
      webp {
        ...ImageDerivativeFragment
      }

      png {
        ...ImageDerivativeFragment
      }
    }

    fragment ImageDerivativeFragment on ImageDerivative {
      maxHeight
      maxWidth

      ...ImageInfoFragment
    }

    fragment ImageInfoFragment on Image {
      alt
      height
      width
      url
      storage
    }
    GRAPHQL
  end

  context "when an attachment is cached" do
    let!(:item) { FactoryBot.create :item, :with_hero_image, :with_thumbnail }

    let!(:expected_shape) do
      format = {
        storage: nil,
        url: nil
      }

      size = {
        webp: format,
        png: format,
      }

      {
        item: {
          hero_image: {
            storage: "CACHE",

            original: {
              storage: "CACHE",
              url: be_present,
            },

            large: size,
            medium: size,
            small: size,
            thumb: size,
          }
        }
      }
    end

    it "looks as expected" do
      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end

  context "when the attachments are processed" do
    let!(:item) { FactoryBot.create :item, :with_hero_image, :with_thumbnail }

    let!(:expected_shape) do
      format = {
        storage: "STORE",
        height: be_present,
        width: be_present,
        url: be_present,
      }

      size = {
        webp: format,
        png: format,
      }

      {
        item: {
          hero_image: {
            storage: "STORE",

            original: {
              storage: "STORE",
              url: be_present,
            },

            large: size,
            medium: size,
            small: size,
            thumb: size,
          }
        }
      }
    end

    it "looks as expected" do
      expect do
        flush_enqueued_jobs
      end.to change { item.reload.thumbnail.storage_key }.from(:cache).to(:store)

      expect_request! do |req|
        req.data! expected_shape
      end
    end
  end
end
