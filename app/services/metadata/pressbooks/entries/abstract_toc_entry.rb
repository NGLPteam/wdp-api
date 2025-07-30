# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Entries
      # @abstract
      class AbstractTOCEntry < ::Metadata::Pressbooks::Entries::Abstract
        attribute :actual_title, :string

        attribute :author_id, :integer

        attribute :comment_count, :integer

        attribute :export, :boolean

        attribute :has_post_content, :boolean

        attribute :menu_order, :integer

        attribute :slug, :string

        attribute :status, :string

        attribute :title, method: :derived_title

        attribute :word_count, :integer

        json do
          map "author", to: :author_id
          map "comment_count", to: :comment_count
          map "export", to: :export
          map "has_post_content", to: :has_post_content
          map "menu_order", to: :menu_order
          map "slug", to: :slug
          map "status", to: :status
          map "title", to: :actual_title
          map "word_count", to: :word_count
        end

        def derived_title
          actual_title.presence || slug.try(:titleize).presence
        end
      end
    end
  end
end
