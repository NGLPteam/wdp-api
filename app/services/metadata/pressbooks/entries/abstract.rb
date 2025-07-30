# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Entries
      # @abstract
      class Abstract < ::Metadata::Pressbooks::Common::AbstractMapper
        attribute :id, :integer
        attribute :link, :string

        json do
          map "id", to: :id
          map "link", to: :link
        end
      end
    end
  end
end
