# frozen_string_literal: true

module Metadata
  module Pressbooks
    class ReferentialLinkTargetHints < ::Metadata::Pressbooks::Common::AbstractMapper
      attribute :allow, :string, collection: true

      json do
        map "allow", to: :allow
      end
    end
  end
end
