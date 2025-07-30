# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Books
      class TOC < ::Metadata::Pressbooks::Common::AbstractMapper
        attribute :front_matters, ::Metadata::Pressbooks::Entries::FrontMatter, collection: true, default: -> { EMPTY_ARRAY }
        attribute :parts, ::Metadata::Pressbooks::Entries::Part, collection: true, default: -> { EMPTY_ARRAY }
        attribute :back_matters, ::Metadata::Pressbooks::Entries::BackMatter, collection: true, default: -> { EMPTY_ARRAY }

        json do
          map "front-matter", to: :front_matters
          map "parts", to: :parts
          map "back-matter", to: :back_matters
        end
      end
    end
  end
end
