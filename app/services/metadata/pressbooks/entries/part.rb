# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Entries
      class Part < ::Metadata::Pressbooks::Entries::AbstractTOCEntry
        attribute :chapters, ::Metadata::Pressbooks::Entries::Chapter, collection: true

        json do
          map "chapters", to: :chapters
        end
      end
    end
  end
end
