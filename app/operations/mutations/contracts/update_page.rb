# frozen_string_literal: true

module Mutations
  module Contracts
    class UpdatePage < ApplicationContract
      json do
        required(:page).value(Support::GlobalTypes.Instance(::Page))
        required(:slug).filled("coercible.string")
      end

      rule(:page, :slug) do
        page = values[:page]
        slug = values[:slug]
        entity = page.entity

        slug_is_not_unique = entity.pages.where.not(id: page.id).by_slug(slug).exists?

        key(:slug).failure(:must_be_unique_slug) if slug_is_not_unique
      end
    end
  end
end
