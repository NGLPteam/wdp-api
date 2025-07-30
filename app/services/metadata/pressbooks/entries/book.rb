# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Entries
      class Book < ::Metadata::Pressbooks::Entries::Abstract
        TOC_URL_SUFFIX = "wp-json/pressbooks/v2/toc"

        attribute :metadata, Metadata::Pressbooks::Books::EmbeddedMetadata
        attribute :links, Metadata::Pressbooks::Books::Links

        attribute :full_metadata_url, method: :derive_full_metadata_url
        attribute :toc_url, method: :derive_toc_url

        json do
          map "metadata", to: :metadata
          map "_links", to: :links
        end

        # @return [String, nil]
        def derive_full_metadata_url
          links.metadata.first.try(:href)
        end

        # @return [String]
        def derive_toc_url
          URI.join(link, TOC_URL_SUFFIX).to_s
        end
      end
    end
  end
end
