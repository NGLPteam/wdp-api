# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Books
      # A shape shared between both embedded and top-level book metadata.
      #
      # @abstract
      class CommonMetadata < ::Metadata::Pressbooks::SchemaDotOrg::Book
        attribute :book_directory_excluded, :boolean

        attribute :language, ::Metadata::Pressbooks::SchemaDotOrg::Language

        json do
          map "bookDirectoryExcluded", to: :book_directory_excluded

          map "language", to: :language
        end
      end
    end
  end
end
