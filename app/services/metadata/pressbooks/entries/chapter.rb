# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Entries
      class Chapter < ::Metadata::Pressbooks::Entries::AbstractTOCEntry
        attribute :metadata, ::Metadata::Pressbooks::SchemaDotOrg::Chapter

        json do
          map "metadata", to: :metadata
        end
      end
    end
  end
end
