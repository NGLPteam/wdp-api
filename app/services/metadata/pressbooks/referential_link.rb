# frozen_string_literal: true

module Metadata
  module Pressbooks
    class ReferentialLink < ::Metadata::Pressbooks::Common::AbstractMapper
      attribute :href, :string
      attribute :target_hints, Metadata::Pressbooks::ReferentialLinkTargetHints

      json do
        map "href", to: :href
        map "targetHints", to: :target_hints
      end
    end
  end
end
