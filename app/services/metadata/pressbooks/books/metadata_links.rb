# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Books
      class MetadataLinks < ::Metadata::Pressbooks::Common::AbstractMapper
        attribute :itself, ::Metadata::Pressbooks::ReferentialLink, collection: true

        json do
          map "self", to: :itself
        end
      end
    end
  end
end
