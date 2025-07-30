# frozen_string_literal: true

require_relative "./creative_work"

module Metadata
  module Pressbooks
    module SchemaDotOrg
      # @see https://schema.org/Book
      class Book < CreativeWork
        attribute :abridged, :boolean
        attribute :illustrators, Person, collection: true
        attribute :isbn, :string
        attribute :page_count, :integer

        json do
          map "abridged", to: :abridged
          map "illustrator", to: :illustrators
          map "isbn", to: :isbn
          map "numberOfPages", to: :page_count
        end
      end
    end
  end
end
