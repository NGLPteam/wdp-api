# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Books
      class Links < ::Metadata::Pressbooks::Common::AbstractMapper
        attribute :api, ::Metadata::Pressbooks::ReferentialLink, collection: true
        attribute :metadata, ::Metadata::Pressbooks::ReferentialLink, collection: true
        attribute :itself, ::Metadata::Pressbooks::ReferentialLink, collection: true

        json do
          map "api", to: :api
          map "metadata", to: :metadata
          map "self", to: :itself
        end
      end
    end
  end
end
