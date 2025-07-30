# frozen_string_literal: true

module Metadata
  module Pressbooks
    module SchemaDotOrg
      # @see https://schema.org/Chapter
      class Chapter < CreativeWork
        attribute :pagination, :string
        attribute :page_start, :string
        attribute :page_end, :string

        json do
          map "pageStart", to: :page_start
          map "pageEnd", to: :page_end
          map "pagination", to: :pagination
        end
      end
    end
  end
end
