# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Books
      # Top-level metadata for a book.
      #
      # For whatever reason, pressbooks structures the metadata that comes back in the /books endpoint
      # differently than the books/:id/metadata endpoint. We have to fetch both.
      class FullMetadata < ::Metadata::Pressbooks::Books::CommonMetadata
        attribute :alternative_headline, :string
        attribute :links, ::Metadata::Pressbooks::Books::MetadataLinks

        json do
          map "alternativeHeadline", to: :alternative_headline
          map "_links", to: :links
        end
      end
    end
  end
end
