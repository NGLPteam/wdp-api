# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Books
      class Record < ::Metadata::Pressbooks::Common::AbstractMapper
        attribute :id, :integer
        attribute :book, ::Metadata::Pressbooks::Entries::Book
        attribute :metadata, ::Metadata::Pressbooks::Books::FullMetadata
        attribute :toc, ::Metadata::Pressbooks::Books::TOC
        attribute :allowed_to_index, method: :check_allowed_to_index

        key_value do
          map :id, to: :id
          map :book, to: :book
          map :metadata, to: :metadata
          map :toc, to: :toc
        end

        # @note Based on the book.metadata.book_directory_excluded property.
        # @return [Boolean]
        def check_allowed_to_index
          book.try(:metadata).try(:book_directory_excluded).blank?
        end
      end
    end
  end
end
